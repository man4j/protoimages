#!/bin/bash
set -e

echo "Starting slaves in dc1..."
docker service create --network dc1 --network monitoring --restart-delay 3m --restart-max-attempts 5 --name=slave_dc1 --constraint "node.labels.dc == dc1" \
-e "MYSQL_PORT=3307" \
-e "SERVICE_PORTS=3307" \
-e "TCP_PORTS=3307" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "MYSQL_MASTER_ROOT_PASSWORD=PassWord123" \
-e "MASTER_HOST=haproxy_group1" \
-e "MASTER_PORT=3306" \
man4j/percona_slave:5.7.17_1
echo "Success"

echo "Starting slaves in dc2..."
docker service create --network dc2 --network monitoring --restart-delay 3m --restart-max-attempts 5 --name=slave_dc2 --constraint "node.labels.dc == dc2" \
-e "MYSQL_PORT=3307" \
-e "SERVICE_PORTS=3307" \
-e "TCP_PORTS=3307" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "MYSQL_MASTER_ROOT_PASSWORD=PassWord123" \
-e "MASTER_HOST=haproxy_group2" \
-e "MASTER_PORT=3306" \
man4j/percona_slave:5.7.17_1
echo "Success"

echo "Starting slaves in dc3..."
docker service create --network dc3 --network monitoring --restart-delay 3m --restart-max-attempts 5 --name=slave_dc3 --constraint "node.labels.dc == dc3" \
-e "MYSQL_PORT=3307" \
-e "SERVICE_PORTS=3307" \
-e "TCP_PORTS=3307" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "MYSQL_MASTER_ROOT_PASSWORD=PassWord123" \
-e "MASTER_HOST=haproxy_group3" \
-e "MASTER_PORT=3306" \
man4j/percona_slave:5.7.17_1
echo "Success"
