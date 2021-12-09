for i in `ls nw_logs/$1_tcpdump_dpid*pcap`
do
        rm -f nw_logs/match
        if grep -P $2 $i| grep -P $3 >> nw_logs/match
        then
                sed -i 's/ /\\s/g' nw_logs/match
                for j in `cat nw_logs/match`
                do
                        rm -f nw_logs/ips nw_logs/begin nw_logs/diff nw_logs/pattern nw_logs/currentmatch nw_logs/ips_opp nw_logs/pattern_opp nw_logs/web_to_$1_tmp nw_logs/$1_to_web_tmp
                        echo $j >>nw_logs/currentmatch
                        grep -B3 `cat nw_logs/currentmatch` $i | grep length| awk -F 'IP|Flags' '{print $2}' >> nw_logs/ips
                        sed -i 's/ /\\s/g' nw_logs/ips
                        cat nw_logs/ips >> nw_logs/pattern
                        sed -i 's/$/Flags\\s\\[F.\\]/g' nw_logs/ips
                        failsafe=`cat nw_logs/pattern`"Flags\s\[(?!P)"
                        begin=`grep -n \`cat nw_logs/currentmatch\` $i|  cut -f1 -d:`
                        diff=`tail -n +$begin $i| grep -n -m1 \`cat nw_logs/ips\`|cut -f1 -d:`
                        if [ -z "$diff" ]; then diff=`tail -n +$begin $i| grep -n -m1 -P $failsafe|cut -f1 -d:`;fi
                        srcip=`tail -n +$begin $i| grep -m1 X-Forwarded-For |cut -f2 -d:`
                        end=$(($begin + $diff))
                        begin=$(($begin - 3))
                        sed -n "${begin},${end}p" $i | grep `cat nw_logs/pattern`| awk '{print $NF}' >> nw_logs/web_to_$1_tmp
                        cat nw_logs/web_to_$1_tmp|awk -v srcip="$srcip" '{ SUM += $1 } END { print srcip,":",SUM}' >> nw_logs/web_to_$1
                        echo $srcip
                        tail -n +$begin $i| grep -B3 -m1 "200\sOK"| grep length | awk -F 'IP|Flags' '{print $2}' >> nw_logs/ips_opp
                        sed -i 's/ /\\s/g' nw_logs/ips_opp
                        cat nw_logs/ips_opp >> nw_logs/pattern_opp
                        sed -i 's/$/Flags\\s\\[F.\\]/g' nw_logs/ips_opp
                        failsafe_opp=`cat nw_logs/pattern_opp`"Flags\s\[(?!P)"
                        begin_opp=`tail -n +$begin $i| grep -n -m1 "200\sOK"|cut -f1 -d:`
                        begin_opp=$(($begin_opp + $begin - 4))
                        diff_opp=`tail -n +$begin_opp $i| grep -n -m1 \`cat nw_logs/ips_opp\`|cut -f1 -d:`
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
