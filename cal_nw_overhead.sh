rm -f nw_logs/search nw_logs/chart nw_logs/cover 
if [ -z "$1" ]
then
        echo "Error :No input provided, ex: k8s"
        exit 1
fi
if [ "$1" = 'k8s' ]
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
	sh get_nw_data.sh search "/api/artists/search\?artist=(?!alt-J)" "/api/artists/search\?artist=(?!shakira)"
	sh get_nw_data.sh search "/api/tracks/search\?title=(?!Nara)" "/api/tracks/search\?title=(?!Nara)"
	sh get_nw_data.sh chart "/api/charts/(?!3XHO7cRUPCLOr6jwp8vsx5)" "/api/charts/(?!0EmeFodog0BfCgMzAIvKQp)"
	sh get_nw_data.sh cover "api/covers/(?!57tzAvfPHXHzCHUNp9AUBm)" "api/covers/(?!2Cd9iWfcOpGDHLz6tVA3G4)"
fi
cat nw_logs/cover| head -`wc -l nw_logs/chart|cut -d " " -f1` >nw_logs/cover
