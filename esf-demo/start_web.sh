#!/bin/bash

set -e

dc_count=$1
constr=$2

net_mask=100.0.0

for ((i=1;i<=$dc_count;i++)) do

echo "Starting esf-web${i} with constraint: ${constr:-dc${i}}..."

docker service create --network web-dc${i} --network percona-dc${i} --network esf-net -p 800${i}:8000 --name esf-web_dc${i} --constraint "node.labels.dc == ${constr:-dc${i}}" \
-e "SERVICE_PORTS=8080" \
-e "COOKIE=SRV insert indirect nocache" \
-e "OPTION=httpchk OPTIONS /esf-web HTTP/1.1\r\nHost:\ www" \
-e "HEALTH_CHECK=check port 8080 inter 5000 rise 1 fall 2" \
-e "JDBC_URL=percona_proxy_dc${i}:3306" \
-e "NET_MASK=${net_mask}" \
-e "JPDA_ADDRESS=8000" \
-e "JPDA_TRANSPORT=dt_socket" \
man4j/esf-web:v7 bin/catalina.sh jpda run

echo "Success"

done


