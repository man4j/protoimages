#!/bin/bash
set -e

dc_count=3
image_version=5.7.16_3
net_mask=10.0.0

echo "Starting galera_init"
docker service create --network skynet --name galera_init --constraint "node.labels.dc == dc1" \
-e "CLUSTER_NAME=mycluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "GMCAST_SEGMENT=1" \
-e "NETMASK=${net_mask}" \
man4j/percona_galera_master:${image_version}

echo "Success, Waiting 60s..."
sleep 60

for ((i=1;i<=$dc_count;i++)) do
  echo "Starting galera in dc${i}..."

  for ((j=1;j<=$dc_count;j++)) do
    if [[ $j != $i ]]; then
      nodes=${nodes},galera_dc${j}
    fi
  done

  docker service create --network skynet --network dc${i} --network monitoring --restart-delay 3m --restart-max-attempts 5 --name galera_dc${i} --constraint "node.labels.dc == dc${i}" \
-e "SERVICE_PORTS=3306" \
-e "TCP_PORTS=3306" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "HTTP_CHECK=OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "CLUSTER_NAME=mycluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "CLUSTER_JOIN=galera_init${nodes}" \
-e "XTRABACKUP_USE_MEMORY=128M" \
-e "GMCAST_SEGMENT=${i}" \
-e "NETMASK=${net_mask}" \
man4j/percona_galera_master:${image_version} --wsrep_slave_threads=2

  nodes=""  
  echo "Success, Waiting 180s..."
  sleep 180
done

echo "Removing galera_init..."
docker service rm galera_init
echo "Success"

