mkdir -p nw_logs
rm -f nw_logs/*

sudo docker images | grep webimage| awk '{print $3}' >> nw_logs/webimage_id
sudo docker ps | grep `cat nw_logs/webimage_id`| awk '{print $NF}' >> nw_logs/webcontainers_id
sudo docker images | grep searchimage| awk '{print $3}' >> nw_logs/searchimage_id
sudo docker ps | grep `cat nw_logs/searchimage_id`| awk '{print $NF}' >> nw_logs/searchcontainers_id
sudo docker images | grep chartimage| awk '{print $3}' >> nw_logs/chartimage_id
sudo docker ps | grep `cat nw_logs/chartimage_id`| awk '{print $NF}' >> nw_logs/chartcontainers_id
sudo docker images | grep coverimage| awk '{print $3}' >> nw_logs/coverimage_id
sudo docker ps | grep `cat nw_logs/coverimage_id`| awk '{print $NF}' >> nw_logs/covercontainers_id
for i in `cat nw_logs/webcontainers_id`
do
        sudo docker run -d --name web_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/web_tcpdump_dpid
done
for i in `cat nw_logs/searchcontainers_id`
do
        sudo docker run -d --name search_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/search_tcpdump_dpid
done
for i in `cat nw_logs/chartcontainers_id`
do
        sudo docker run -d --name chart_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/chart_tcpdump_dpid
done
for i in `cat nw_logs/covercontainers_id`
do
        sudo docker run -d --name cover_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/cover_tcpdump_dpid
done
