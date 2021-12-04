mkdir -p nw_logs
rm -f nw_logs/*

sudo docker ps | grep localhost:5000/webimage | awk '{print $NF}' >> nw_logs/webcontainers_id

sudo docker ps | grep localhost:5000/searchimage | awk '{print $NF}' >> nw_logs/searchcontainers_id
sudo docker ps | grep localhost:5000/chartimage | awk '{print $NF}' >> nw_logs/chartcontainers_id
sudo docker ps | grep localhost:5000/coverimage | awk '{print $NF}' >> nw_logs/covercontainers_id


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
