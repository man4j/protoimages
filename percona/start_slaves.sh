#!/bin/bash
set -e

dc_count=3
image_version=5.7.17_3

for i in {1..$dc_count}; do
  echo "Starting slaves in dc${i}..."
  
  docker service create --network dc${i} --network monitoring --restart-delay 3m --restart-max-attempts 5 --name=slave_dc${i} --constraint "node.labels.dc == dc${i}" \
  -e "MYSQL_PORT=3307" \
  -e "SERVICE_PORTS=3307" \
  -e "TCP_PORTS=3307" \
  -e "BALANCE=source" \
  -e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
  -e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
  -e "MYSQL_ROOT_PASSWORD=PassWord123" \
  -e "MYSQL_MASTER_ROOT_PASSWORD=PassWord123" \
  -e "MASTER_HOST=haproxy_dc${i}" \
  -e "MASTER_PORT=3306" \
  man4j/percona_slave:${image_version}
  echo "Success"
done