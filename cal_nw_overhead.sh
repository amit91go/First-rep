rm -f nw_logs/web_to_search nw_logs/web_to_chart nw_logs/search_to_web nw_logs/chart_to_web nw_logs/web_to_cover nw_logs/cover_to_web
if [ -z "$1" ]
then
	sh get_nw_data.sh search
	sh get_nw_data.sh chart 
	sh get_nw_data.sh cover
elif [ $1 == 'dcos' ]
then
	sh get_nw_data.sh search "/api/artists/search\?artist=(?!alt-J)"
	sh get_nw_data.sh search "/api/tracks/search\?title=(?!Nara)"
	sh get_nw_data.sh chart "/api/charts/(?!3XHO7cRUPCLOr6jwp8vsx5)"
	sh get_nw_data.sh cover "api/covers/(?!57tzAvfPHXHzCHUNp9AUBm)"
elif [ $1 == 'nomad' ]
then
	sh get_nw_data.sh search "/api/artists/search\?artist=(?!alt-J)" "/api/artists/search\?artist=(?!shaan)"
	sh get_nw_data.sh search "/api/tracks/search\?title=(?!Nara)" "/api/tracks/search\?title=(?!Nara)"
	sh get_nw_data.sh chart "/api/charts/(?!3XHO7cRUPCLOr6jwp8vsx5)" "/api/charts/(?!5cB4d4jPYjMT326sjihQ4m)"
	sh get_nw_data.sh cover "api/covers/(?!57tzAvfPHXHzCHUNp9AUBm)" "api/covers/(?!5EYZZvmNAH5VZCwuzYJqoA)"
fi
