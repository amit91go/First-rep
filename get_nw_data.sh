for i in `ls nw_logs/$1_tcpdump_dpid*pcap`
do
        rm -f nw_logs/match
	if [ -z "$2" ]
	then
		grep "GET /api/" $i >> nw_logs/match
	elif [ -z "$3" ]
	then
		grep -P $2 $i >> nw_logs/match
	else
		grep -P $2 $i| grep -P $3 >> nw_logs/match
	fi
	if [ -s nw_logs/match ]
        then
                sed -i 's/ /\\s/g' nw_logs/match
                for j in `cat nw_logs/match`
                do
                        rm -f nw_logs/ips nw_logs/begin nw_logs/diff nw_logs/pattern nw_logs/currentmatch nw_logs/ips_opp nw_logs/pattern_opp nw_logs/web_to_$1_tmp nw_logs/$1_to_web_tmp
                        echo $j|awk -F 'GET' '{print $2}' >>nw_logs/currentmatch
                        grep -B4 `cat nw_logs/currentmatch` $i | grep length| tail -1| awk -F 'IP|Flags' '{print $2}' >> nw_logs/ips
                        sed -i 's/ /\\s/g' nw_logs/ips
                        cat nw_logs/ips >> nw_logs/pattern
                        sed -i 's/$/Flags\\s\\[F.\\]/g' nw_logs/ips
                        failsafe=`cat nw_logs/pattern`"Flags\s\[(?!P)"
                        begin=`grep -n \`cat nw_logs/currentmatch\` $i|  cut -f1 -d:`
			echo $begin
                        diff=`tail -n +$begin $i| grep -n -m1 \`cat nw_logs/ips\`|cut -f1 -d:`
                        if [ -z "$diff" ]; then diff=`tail -n +$begin $i| grep -n -m1 -P $failsafe|cut -f1 -d:`;fi
			echo $begin,$i
                        srcip=`tail -n +$begin $i| grep -m1 -e X-Forwarded-For -e Srcip|cut -f2 -d:`
			echo $srcip
                        end=$(($begin + $diff))
                        begin=$(($begin - 4))
                        sed -n "${begin},${end}p" $i | grep `cat nw_logs/pattern`| awk '{print $NF}' >> nw_logs/web_to_$1_tmp
                        cat nw_logs/web_to_$1_tmp|awk -v srcip="$srcip" '{ SUM += $1 } END { print srcip,":",SUM}' >> nw_logs/web_to_$1
                        echo $srcip
                        tail -n +$begin $i| grep -B4 -m1 "200\sOK"| grep length |tail -1| awk -F 'IP|Flags' '{print $2}' >> nw_logs/ips_opp
			echo $srcip
                        sed -i 's/ /\\s/g' nw_logs/ips_opp
                        cat nw_logs/ips_opp >> nw_logs/pattern_opp
                        sed -i 's/$/Flags\\s\\[F.\\]/g' nw_logs/ips_opp
                        failsafe_opp=`cat nw_logs/pattern_opp`"Flags\s\[(?!P)"
			echo $srcip
                        begin_opp=`tail -n +$begin $i| grep -n -m1 "200\sOK"|cut -f1 -d:`
			echo $srcip
                        begin_opp=$(($begin_opp + $begin - 5))
			echo $begin_opp
                        diff_opp=`tail -n +$begin_opp $i| grep -n -m1 \`cat nw_logs/ips_opp\`|cut -f1 -d:`
			echo $diff_opp
                        if [ -z "$diff_opp" ]; then diff_opp=`tail -n +$begin_opp $i| grep -n -m1 -P $failsafe_opp|cut -f1 -d:`;fi
                        end_opp=$(($begin_opp + $diff_opp - 1))
                        sed -n "${begin_opp},${end_opp}p" $i | grep `cat nw_logs/pattern_opp`| awk '{print $NF}' >> nw_logs/$1_to_web_tmp
                        cat nw_logs/$1_to_web_tmp |awk -v srcip="$srcip" '{ SUM += $1 } END { print srcip,":",SUM}' >> nw_logs/$1_to_web
                done
                sed -i 's/ //g' nw_logs/web_to_$1
                sed -i 's/ //g' nw_logs/$1_to_web
                sed -i 's///g' nw_logs/web_to_$1
                sed -i 's///g' nw_logs/$1_to_web
        fi
done
rm -f nw_logs/ips nw_logs/begin nw_logs/diff nw_logs/pattern nw_logs/currentmatch nw_logs/ips_opp nw_logs/pattern_opp nw_logs/match nw_logs/web_to_$1_tmp nw_logs/$1_to_web_tmp
