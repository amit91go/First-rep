rm -f nw_logs/tcpdumpidfiles
ls -l nw_logs/*tcpdump_dpid*| awk '{print $NF}' >>nw_logs/tcpdumpidfiles
for i in `cat nw_logs/tcpdumpidfiles`
do
	sudo docker stop `cat $i`
	sudo docker logs `cat $i` >> $i.pcap
	sudo docker rm `cat $i`
done

