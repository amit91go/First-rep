rm -f tcpdumpidfiles
ls -l *tcpdump_dpid*| awk '{print $NF}' >>tcpdumpidfiles
for i in `cat tcpdumpidfiles`
do
	sudo docker stop `cat $i`
done

