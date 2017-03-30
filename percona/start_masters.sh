#!/bin/bash
set -e

echo "Starting galera_init"
docker service create --network skynet --name galera_init --constraint "node.labels.dc == dc1" \
-e "CLUSTER_NAME=mycluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "GMCAST_SEGMENT=1" \
-e "NETMASK=10.0.0" \
man4j/percona_galera_master:5.7.16_1
echo "Success"

echo "Waiting 60s..."
sleep 60

echo "Starting galera in dc1..."
docker service create --network skynet --network dc1 --network monitoring --restart-delay 3m --restart-max-attempts 5 --name galera_dc1 --constraint "node.labels.dc == dc1" \
-e "SERVICE_PORTS=3306" \
-e "TCP_PORTS=3306" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "CLUSTER_NAME=mycluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "CLUSTER_JOIN=galera_init,galera_dc2,galera_dc3" \
-e "GMCAST_SEGMENT=1" \
-e "NETMASK=10.0.0" \
man4j/percona_galera_master:5.7.16_1
echo "Success"

echo "Waiting 180s..."
sleep 180

echo "Starting galera in dc2..."
docker service create --network skynet --network dc2 --network monitoring --restart-delay 3m --restart-max-attempts 5 --name galera_dc2 --constraint "node.labels.dc == dc2" \
-e "SERVICE_PORTS=3306" \
-e "TCP_PORTS=3306" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "CLUSTER_NAME=mycluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "CLUSTER_JOIN=galera_init,galera_dc1,galera_dc3" \
-e "GMCAST_SEGMENT=2" \
-e "NETMASK=10.0.0" \
man4j/percona_galera_master:5.7.16_1
echo "Success"

echo "Waiting 180s..."
sleep 180

echo "Starting galera in dc3..."
docker service create --network skynet --network dc3 --network monitoring --restart-delay 3m --restart-max-attempts 5 --name galera_dc3 --constraint "node.labels.dc == dc3" \
-e "SERVICE_PORTS=3306" \
-e "TCP_PORTS=3306" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "CLUSTER_NAME=mycluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "CLUSTER_JOIN=galera_init,galera_dc1,galera_dc2" \
-e "GMCAST_SEGMENT=3" \
-e "NETMASK=10.0.0" \
man4j/percona_galera_master:5.7.16_1
echo "Success"

echo "Waiting 180s..."
sleep 180

echo "Removing galera_init..."
docker service rm galera_init
echo "Success"

