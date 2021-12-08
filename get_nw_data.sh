for i in `ls nw_logs/$1_tcpdump_dpid*pcap`
do
	rm -f nw_logs/match
	if grep -P $2 $i >> nw_logs/match
	then
		sed -i 's/ /\\s/g' nw_logs/match
		for j in `cat nw_logs/match`
		do
			rm -f nw_logs/ips nw_logs/begin nw_logs/diff nw_logs/pattern nw_logs/currentmatch nw_logs/ips_opp nw_logs/pattern_opp
			echo $j >>nw_logs/currentmatch
			grep -B3 `cat nw_logs/currentmatch` $i | grep length| awk -F 'IP|Flags' '{print $2}' >> nw_logs/ips
			sed -i 's/ /\\s/g' nw_logs/ips
			cat nw_logs/ips >> nw_logs/pattern
			sed -i 's/$/Flags\\s\\[F.\\]/g' nw_logs/ips
			begin=`grep -n \`cat nw_logs/currentmatch\` $i|  cut -f1 -d:`
			diff=`tail -n +$begin $i| grep -n -m1 \`cat nw_logs/ips\`|cut -f1 -d:`
			end=$(($begin + $diff))
			begin=$(($begin - 2))
			sed -n "${begin},${end}p" $i | grep `cat nw_logs/pattern`| awk '{print $NF}' >> nw_logs/web_to_$1
			tail -n +$begin $i| grep -B3 -m1 "200\sOK"| grep length | awk -F 'IP|Flags' '{print $2}' >> nw_logs/ips_opp
			sed -i 's/ /\\s/g' nw_logs/ips_opp
			cat nw_logs/ips_opp >> nw_logs/pattern_opp
			sed -i 's/$/Flags\\s\\[F.\\]/g' nw_logs/ips_opp
			begin_opp=`tail -n +$begin $i| grep -n -m1 "200\sOK"|cut -f1 -d:`
			begin_opp=$(($begin_opp + $begin - 3))
			diff_opp=`tail -n +$begin_opp $i| grep -n -m1 \`cat nw_logs/ips_opp\`|cut -f1 -d:`
			end_opp=$(($begin_opp + $diff_opp - 1))
			sed -n "${begin_opp},${end_opp}p" $i | grep `cat nw_logs/pattern_opp`| awk '{print $NF}' >> nw_logs/$1_to_web
		done
	fi
done
rm -f nw_logs/ips nw_logs/begin nw_logs/diff nw_logs/pattern nw_logs/currentmatch nw_logs/ips_opp nw_logs/pattern_opp nw_logs/match
