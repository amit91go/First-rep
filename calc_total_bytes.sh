rm -f nw_logs/*data.pcap nw_logs/*len nw_logs/*ips

cat nw_logs/web_tcpdump_dpid.pcap | grep "search.8081 >" >>nw_logs/search_to_web_data.pcap
cat nw_logs/search_to_web_data.pcap| awk '{print $NF}' >>nw_logs/search_to_web_len
cat nw_logs/web_tcpdump_dpid.pcap | grep -e "Srcip: 192.168.41.152" -e "Srcip: 192.168.77.135" >>nw_logs/search_to_web_ips

cat nw_logs/web_tcpdump_dpid.pcap | grep "images.8082 >" >>nw_logs/cover_to_web_data.pcap
cat nw_logs/cover_to_web_data.pcap| awk '{print $NF}' >>nw_logs/cover_to_web_len
cat nw_logs/web_tcpdump_dpid.pcap | grep -e "Srcip: 192.168.41.153" -e "Srcip: 192.168.77.140" >>nw_logs/cover_to_web_ips

cat nw_logs/web_tcpdump_dpid.pcap | grep "charts.8083 >" >>nw_logs/chart_to_web_data.pcap
cat nw_logs/chart_to_web_data.pcap| awk '{print $NF}' >>nw_logs/chart_to_web_len
cat nw_logs/web_tcpdump_dpid.pcap | grep -e "Srcip: 192.168.77.139" -e "Srcip: 192.168.41.157" >>nw_logs/chart_to_web_ips

cat nw_logs/search_tcpdump_dpid.pcap | grep -e "IP 192-168-77-143" -e "IP 192-168-41-155" >>nw_logs/web_to_search_data.pcap
cat nw_logs/web_to_search_data.pcap| awk '{print $NF}' >>nw_logs/web_to_search_len
cat nw_logs/search_tcpdump_dpid.pcap | grep -e "Srcip: 192.168.41.155" -e "Srcip: 192.168.77.143" >>nw_logs/web_to_search_ips

cat nw_logs/cover_tcpdump_dpid.pcap | grep -e "IP 192-168-77-143" -e "IP 192-168-41-155" >>nw_logs/web_to_cover_data.pcap
cat nw_logs/web_to_cover_data.pcap| awk '{print $NF}' >>nw_logs/web_to_cover_len
cat nw_logs/cover_tcpdump_dpid.pcap | grep -e "Srcip: 192.168.41.155" -e "Srcip: 192.168.77.143" >>nw_logs/web_to_cover_ips

cat nw_logs/chart_tcpdump_dpid.pcap | grep -e "IP 192-168-77-143" -e "IP 192-168-41-155" >>nw_logs/web_to_chart_data.pcap
cat nw_logs/web_to_chart_data.pcap| awk '{print $NF}' >>nw_logs/web_to_chart_len
cat nw_logs/chart_tcpdump_dpid.pcap | grep -e "Srcip: 192.168.41.155" -e "Srcip: 192.168.77.143" >>nw_logs/web_to_chart_ips

#rm -f nw_logs/total_bytes nw_logs/total_bytes_per_ip
sum1=0
line1=1
for j in `cat nw_logs/search_to_web_len`
do
        echo $j
        if [ $j -eq  0 ]
        then
                if [ $sum1 -eq 0 ]
                then
                       continue;
                else
                       #echo $sum >> nw_logs/total_bytes
                       sed -i "${line1}s/$/:${sum1}/" nw_logs/search_to_web_ips
                       line1=$((line1+1))
                       sum1=0
                fi
        else
                sum1=$((sum1+j))
        fi
done

sed -i 's/Srcip: //g' nw_logs/search_to_web_ips
sed -i 's///g' nw_logs/search_to_web_ips


sum2=0
line2=1
for j in `cat nw_logs/cover_to_web_len`
do
        echo $j
        if [ $j -eq  0 ]
        then
                if [ $sum2 -eq 0 ]
                then
                       continue;
                else
                       #echo $sum >> nw_logs/total_bytes
                       sed -i "${line2}s/$/:${sum2}/" nw_logs/cover_to_web_ips
                       line2=$((line2+1))
                       sum2=0
                fi
        else
                sum2=$((sum2+j))
        fi
done

sed -i 's/Srcip: //g' nw_logs/cover_to_web_ips
sed -i 's///g' nw_logs/cover_to_web_ips

sum3=0
line3=1
for j in `cat nw_logs/chart_to_web_len`
do
        echo $j
        if [ $j -eq  0 ]
        then
                if [ $sum3 -eq 0 ]
                then
                       continue;
                else
                       #echo $sum >> nw_logs/total_bytes
                       sed -i "${line3}s/$/:${sum3}/" nw_logs/chart_to_web_ips
                       line3=$((line3+1))
                       sum3=0
                fi
        else
                sum3=$((sum3+j))
        fi
done

sed -i 's/Srcip: //g' nw_logs/chart_to_web_ips
sed -i 's///g' nw_logs/chart_to_web_ips


sum4=0
line4=1
for j in `cat nw_logs/web_to_search_len`
do
        echo $j
        if [ $j -eq  0 ]
        then
                if [ $sum4 -eq 0 ]
                then
                       continue;
                else
                       #echo $sum >> nw_logs/total_bytes
                       sed -i "${line4}s/$/:${sum4}/" nw_logs/web_to_search_ips
                       line4=$((line4+1))
                       sum4=0
                fi
        else
                sum4=$((sum4+j))
        fi
done

sed -i 's/Srcip: //g' nw_logs/web_to_search_ips
sed -i 's///g' nw_logs/web_to_search_ips


sum5=0
line5=1
for j in `cat nw_logs/web_to_cover_len`
do
        echo $j
        if [ $j -eq  0 ]
        then
                if [ $sum5 -eq 0 ]
                then
                       continue;
                else
                       #echo $sum >> nw_logs/total_bytes
                       sed -i "${line5}s/$/:${sum5}/" nw_logs/web_to_cover_ips
                       line5=$((line5+1))
                       sum5=0
                fi
        else
                sum5=$((sum5+j))
        fi
done

sed -i 's/Srcip: //g' nw_logs/web_to_cover_ips
sed -i 's///g' nw_logs/web_to_cover_ips



sum6=0
line6=1
for j in `cat nw_logs/web_to_chart_len`
do
        echo $j
        if [ $j -eq  0 ]
        then
                if [ $sum6 -eq 0 ]
                then
                       continue;
                else
                       #echo $sum >> nw_logs/total_bytes
                       sed -i "${line6}s/$/:${sum6}/" nw_logs/web_to_chart_ips
                       line6=$((line6+1))
                       sum6=0
                fi
        else
                sum6=$((sum6+j))
        fi
done

sed -i 's/Srcip: //g' nw_logs/web_to_chart_ips
sed -i 's///g' nw_logs/web_to_chart_ips
