#!/bin/bash
set -e

dc_count=$1
constr=$2

image_version=5.7.16_2
net_mask=100.0.0

echo "Starting percona_init with constraint: ${constr:-dc1}..."
docker service create --network esf-net --name percona_init --constraint "node.labels.dc == ${constr:-dc1}" \
-e "CLUSTER_NAME=esfcluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "GMCAST_SEGMENT=1" \
-e "NETMASK=${net_mask}" \
man4j/esf_percona:${image_version}

echo "Success, Waiting 60s..."
sleep 60

for ((i=1;i<=$dc_count;i++)) do
  echo "Starting percona in dc${i} with constraint: ${constr:-dc${i}}..."

  nodes="percona_init"

  for ((j=1;j<=$dc_count;j++)) do
    if [[ $j != $i ]]; then
      nodes=${nodes},percona_dc${j}
    fi
  done

  docker service create --network esf-net --network percona-dc${i} --restart-delay 3m --restart-max-attempts 5 --name percona_dc${i} --constraint "node.labels.dc == ${constr:-dc${i}}" \
-e "SERVICE_PORTS=3306" \
-e "TCP_PORTS=3306" \
-e "BALANCE=source" \
-e "HEALTH_CHECK=check port 9200 inter 5000 rise 1 fall 2" \
-e "OPTION=httpchk OPTIONS * HTTP/1.1\r\nHost:\ www" \
-e "CLUSTER_NAME=esfcluster" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
-e "CLUSTER_JOIN=${nodes}" \
-e "XTRABACKUP_USE_MEMORY=128M" \
-e "GMCAST_SEGMENT=${i}" \
-e "NETMASK=${net_mask}" \
man4j/esf_percona:${image_version} --wsrep_slave_threads=2

  nodes=""  
  echo "Success, Waiting 180s..."
  sleep 180
done

echo "Removing percona_init..."
docker service rm percona_init
echo "Success"

