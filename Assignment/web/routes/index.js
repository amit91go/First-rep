var express = require('express');
var rest = require('restler');
var async = require('async');
var router = express.Router();
const client = require('prom-client');

// Create a Registry which registers the metrics
const http = require('http')
const url = require('url')
const register = new client.Registry()

// Add a default label which is added to all metrics
register.setDefaultLabels({
  app: 'nodejs-frontend'
})

// Enable the collection of default metrics
client.collectDefaultMetrics({ register })

const httpRequestTotal = new client.Counter({
  name: 'http_request_total',
  help: 'Total number of HTTP requests processed'
});
register.registerMetric(httpRequestTotal);

const httpRequestDurationMicroseconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in microseconds',
  labelNames: ['method', 'route', 'code'],
  buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10]
});
register.registerMetric(httpRequestDurationMicroseconds);
var os = require('os');

var interfaces = os.networkInterfaces();
var addresses = [];
for (var k in interfaces) {
    for (var k2 in interfaces[k]) {
        var address = interfaces[k][k2];
        if (address.family === 'IPv4' && !address.internal) {
            addresses.push(address.address);
        }
    }
}

console.log(addresses);

/* GET home page. */
router.get('/', function(req, res, next) {
  const end = httpRequestDurationMicroseconds.startTimer();
  const route = url.parse(req.url).pathname;
  var title = (req.query.title === undefined) ? 'Nara' : req.query.title;
  var artist = (req.query.artist === undefined) ? 'alt-J' : req.query.artist;
  req.headers['srcIP'] = addresses[0];

  async.parallel([
      function(callback){
        // get top songs
        console.log('Artist is ' + artist);

        rest.get('http://search:8081/api/artists/search?artist=' + artist, {headers : {Srcip: addresses[0]}}).on('complete', function(data) {
          console.log('Artist ID is ' + data["id"]);
          console.log('req headers ' + JSON.stringify(req.headers));
          rest.get('http://charts:8083/api/charts/' + data["id"], {headers : {Srcip: addresses[0]}}).on('complete', function(data) {
            console.log('Top songs are ' + JSON.stringify(data));
            callback(null, data);
          });
        });
      },
      function(callback){
          // get cover data
          console.log('Title is ' + title);

          rest.get('http://search:8081/api/tracks/search?title=' + title + '&artist=' + artist, {headers : {Srcip: addresses[0]}}).on('complete', function(data) {
            console.log('Title ID is ' + data["id"]);

            rest.get('http://images:8082/api/covers/' + data["id"], {headers : {Srcip: addresses[0]}}).on('complete', function(data) {
              console.log('Cover image is ' + data["url"]);
              callback(null, data["url"]);
            });
          });
      }
  ],
  function(err, results){
      if(results[1] == undefined || results[1] == "") {
        results[1] = 'images/nocover.png';
      }
	  console.log('Service requested');
      // the results array will equal ['top tracks','cover_url']
      res.render('index', { title: 'Music Recommender', song: title, artist: artist, cover: results[1], charts: results[0] });
  });
  httpRequestTotal.inc();
  end({route, code: res.statusCode, method: req.method });
});


router.get('/metrics', function(req, res, next) {
  res.setHeader('Content-Type', register.contentType)
  res.send(register.metrics());
});

module.exports = router;
