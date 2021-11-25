rm -f webimage_id webcontainers_id web_tcpdump_dpid
sudo docker images | grep webimage| awk '{print $3}' >> webimage_id
sudo docker ps | grep `cat webimage_id`| awk '{print $NF}' >> webcontainers_id
rm -f searchimage_id searchcontainers_id search_tcpdump_dpid
sudo docker images | grep searchimage| awk '{print $3}' >> searchimage_id
sudo docker ps | grep `cat searchimage_id`| awk '{print $NF}' >> searchcontainers_id
rm -f chartimage_id chartcontainers_id chart_tcpdump_dpid
sudo docker images | grep chartimage| awk '{print $3}' >> chartimage_id
sudo docker ps | grep `cat chartimage_id`| awk '{print $NF}' >> chartcontainers_id
rm -f coverimage_id covercontainers_id cover_tcpdump_dpid
sudo docker images | grep coverimage| awk '{print $3}' >> coverimage_id
sudo docker ps | grep `cat coverimage_id`| awk '{print $NF}' >> covercontainers_id
for i in `cat webcontainers_id`
do
	echo $i
	sudo docker run -d --name web_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>web_tcpdump_dpid
done
for i in `cat searchcontainers_id`
do
	echo $i
	sudo docker run -d --name search_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>search_tcpdump_dpid
done
for i in `cat chartcontainers_id`
do
	sudo docker run -d --name chart_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>chart_tcpdump_dpid
done
for i in `cat covercontainers_id`
do
	sudo docker run -d --name cover_tcpdump --tty --net=container:$i tcpdump tcpdump -N -A >>cover_tcpdump_dpid
done
