rm -f /tmp/job /tmp/deps deployments workernodes nw_transmissions

for i in `cat nodes|cut -d ":" -f1`
do
        hostname="$i"
        cpuvar=100
	memvar=`./promql node_memory_MemTotal_bytes| grep $i| awk '{print $9}'`
        cpuutilvar=`./promql "100 - (avg by (instance) (irate(node_cpu_seconds_total{job=\"node-exporter\",mode=\"idle\"}[5m])) * 100)"| grep $i| awk '{print $2}'`
        memutilvar=`./promql "node_memory_MemTotal_bytes - avg_over_time(node_memory_MemAvailable_bytes[15m])"| grep $i| awk '{print $8}'`
	nodename=`grep $i nodes|cut -d ":" -f2`
        conatners=`kubectl get pods -o wide| grep "\-d\-"| grep $nodename| cut -d "-" -f1|awk '{ORS = "service "}{print $1}'`

        jq -n -r --arg hostName "$hostname" --arg totalCPU "$cpuvar" --arg totalMemory "$memvar" --arg cpuUtilisation "$cpuutilvar" --arg memoryUtilisation "$memutilvar" --arg runningContainers "$conatners" '{hostName:$hostName,totalCPU:$totalCPU,totalMemory:$totalMemory,cpuUtilisation:$cpuUtilisation,memoryUtilisation:$memoryUtilisation,runningContainers:$runningContainers}' >>workernodes
done
jq -s '.' workernodes > nodes.json

kubectl get deployments | grep "\-d\-" | cut -d "-" -f1>>/tmp/deps
for i in `cat /tmp/deps`
do
        deployment=`echo $i`service
	sum=0
        if [ "$i" = 'web' ]
        then
                for j in `ls chart*_nwdata`; do sum=$(( $sum + `wc -l $j| cut -d " " -f1` )); done
        else
                for j in `ls $i*_nwdata`; do sum=$(( $sum + `wc -l $j| cut -d " " -f1` )); done
        fi
        totalIncomingReq=$sum
        cpuRequired=`./promql "max(rate(container_cpu_usage_seconds_total{pod=~\"$i.*\"}[15m]) * 100)"| head -2| tail -1| awk '{print $1}'`
        memoryRequired=`./promql "max(avg_over_time(container_memory_usage_bytes{pod=~\"$i.*\"}[15m]))"| head -2| tail -1| awk '{print $1}'`
        totalRunningContainers=`kubectl get pods| grep -c $i`

        jq -n -r --arg deployment "$deployment" --arg totalIncomingReq "$totalIncomingReq" --arg cpuRequired "$cpuRequired" --arg memoryRequired "$memoryRequired" --arg totalRunningContainers "$totalRunningContainers" '{deployment:$deployment,totalIncomingReq:$totalIncomingReq,cpuRequired:$cpuRequired,memoryRequired:$memoryRequired,totalRunningContainers:$totalRunningContainers}' >>deployments
done
jq -s '.' deployments > deployments.json

for i in `ls *_nwdata`
do
        consumer=webservice
        provider=`echo $i|cut -d "_" -f1`service
        noOfRequests=`wc -l $i| cut -d " " -f1`
        bytesTransmitted=`for j in \`cat $i\`; do sum=$((sum + \`echo $j| cut -d ":" -f2\`)); done; echo $sum`

        jq -n -r --arg consumer "$consumer" --arg provider "$provider" --arg noOfRequests "$noOfRequests" --arg bytesTransmitted "$bytesTransmitted" '{consumer:$consumer,provider:$provider,noOfRequests:$noOfRequests,bytesTransmitted:$bytesTransmitted}' >>nw_transmissions
done
jq -s '.' nw_transmissions > nw_transmissions.json
