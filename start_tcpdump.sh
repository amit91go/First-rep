mkdir -p nw_logs
rm -f nw_logs/*
if [ -z "$1" ]
then
	echo "Error :No input provided, ex: K8s"
	exit 1
fi
if [ "$1" = 'k8s' ]
then
	sudo docker images | grep searchimage| awk '{print $3}' >> nw_logs/searchimage_id
	sudo docker ps | grep `cat nw_logs/searchimage_id`| awk '{print $NF}' >> nw_logs/searchcontainers_id
	sudo docker images | grep chartimage| awk '{print $3}' >> nw_logs/chartimage_id
	sudo docker ps | grep `cat nw_logs/chartimage_id`| awk '{print $NF}' >> nw_logs/chartcontainers_id
	sudo docker images | grep coverimage| awk '{print $3}' >> nw_logs/coverimage_id
	sudo docker ps | grep `cat nw_logs/coverimage_id`| awk '{print $NF}' >> nw_logs/covercontainers_id
else
	sudo docker ps | grep localhost:5000/searchimage | awk '{print $NF}' >> nw_logs/searchcontainers_id
	sudo docker ps | grep localhost:5000/chartimage | awk '{print $NF}' >> nw_logs/chartcontainers_id
	sudo docker ps | grep localhost:5000/coverimage | awk '{print $NF}' >> nw_logs/covercontainers_id
fi

for i in `cat nw_logs/searchcontainers_id`
do
        sudo docker run -d --name search_tcpdump_$i --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/search_tcpdump_dpid_$i
done
for i in `cat nw_logs/chartcontainers_id`
do
        sudo docker run -d --name chart_tcpdump_$i --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/chart_tcpdump_dpid_$i
done
for i in `cat nw_logs/covercontainers_id`
do
        sudo docker run -d --name cover_tcpdump_$i --tty --net=container:$i tcpdump tcpdump -N -A >>nw_logs/cover_tcpdump_dpid_$i
done
