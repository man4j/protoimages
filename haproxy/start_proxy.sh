#!/bin/bash
set -e

echo "Starting haproxy in dc1..."
docker service create --network dc1 --name haproxy_dc1 --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "node.labels.dc == dc1" dockercloud/haproxy
echo "Success"

echo "Starting haproxy in dc2..."
docker service create --network dc2 --name haproxy_dc2 --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "node.labels.dc == dc2" dockercloud/haproxy
echo "Success"

echo "Starting haproxy in dc3..."
docker service create --network dc3 --name haproxy_dc3 --mount target=/var/run/docker.sock,source=/var/run/docker.sock,type=bind --constraint "node.labels.dc == dc3" dockercloud/haproxy
echo "Success"


