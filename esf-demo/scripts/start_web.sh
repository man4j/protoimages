#!/bin/bash

set -e

dc_count=$1
constr=$2

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

net_mask=100.0.0

for ((i=1;i<=$dc_count;i++)) do
  docker network create --driver overlay --attachable --subnet=${i}.0.2.0/24 web-dc${i}

  echo "Starting esf-web with constraint: ${constr:-dc${i}}..."
  docker service create --detach=false --network web-dc${i} --network percona-dc${i} --network voltdb-net --network kafka-net -p 800${i}:8000 --name esf_web_dc${i} --constraint "engine.labels.dc == ${constr:-dc${i}}" \
-e "SERVICE_PORTS=8080" \
-e "COOKIE=SRV insert indirect nocache" \
-e "OPTION=httpchk OPTIONS /esf-web HTTP/1.1\r\nHost:\ www" \
-e "HEALTH_CHECK=check port 8080 inter 5000 rise 1 fall 2" \
-e "JDBC_URL=percona_proxy_dc${i}:3306" \
-e "KAFKA_BROKERS=kafka_dc1:9092,kafka_dc2:9092,kafka_dc3:9092" \
-e "VOLTDB_HOSTS=voltdb_dc1:21212,voltdb_dc2:21212,voltdb_dc3:21212" \
-e "NET_MASK=${net_mask}" \
-e "JPDA_ADDRESS=8000" \
-e "JPDA_TRANSPORT=dt_socket" \
man4j/esf-web:v8 bin/catalina.sh jpda run

  echo "Starting haproxy with constraint: ${constr:-dc${i}}..."
  docker service create --detach=false --network web-dc${i} -p 8${i}:80 --name web_proxy_dc${i} --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "engine.labels.dc == ${constr:-dc${i}}" \
-e "EXTRA_GLOBAL_SETTINGS=stats socket 0.0.0.0:14567" \
dockercloud/haproxy:1.6.7

  echo "Success"
done