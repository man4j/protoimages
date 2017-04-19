#!/bin/bash
set -e

dc_count=3

for ((i=1;i<=$dc_count;i++)) do 

echo "Starting haproxy in dc${i}..."
docker service create --network dc${i} --name haproxy_dc${i} --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "node.labels.dc == dc${i}" \
-e "EXTRA_GLOBAL_SETTINGS=stats socket 0.0.0.0:14567" \
dockercloud/haproxy
echo "Success"

done