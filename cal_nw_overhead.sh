rm -f nw_logs/web_to_search nw_logs/web_to_chart nw_logs/search_to_web nw_logs/chart_to_web nw_logs/web_to_cover nw_logs/cover_to_web
sh get_nw_data.sh search "/api/artists/search\?artist=(?!alt-J)"
sh get_nw_data.sh search "/api/tracks/search\?title=(?!Nara)"
sh get_nw_data.sh chart "/api/charts/(?!3XHO7cRUPCLOr6jwp8vsx5)"
sh get_nw_data.sh cover "api/covers/(?!57tzAvfPHXHzCHUNp9AUBm)"
