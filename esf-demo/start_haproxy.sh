#!/bin/bash
set -e

dc_count=$1
constr=$2

for ((i=1;i<=$dc_count;i++)) do 

echo "Starting haproxy in dc${i} with constraint: ${constr:-dc${i}}..."

docker service create --network percona-dc${i} --name percona_proxy_dc${i} --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "node.labels.dc == ${constr:-dc${i}}" \
-e "EXTRA_GLOBAL_SETTINGS=stats socket 0.0.0.0:14567" \
dockercloud/haproxy

docker service create --network web-dc${i} -p 8${i}:80 --name web_proxy_dc${i} --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "node.labels.dc == ${constr:-dc${i}}" \
-e "EXTRA_GLOBAL_SETTINGS=stats socket 0.0.0.0:14567" \
dockercloud/haproxy

echo "Success"

done