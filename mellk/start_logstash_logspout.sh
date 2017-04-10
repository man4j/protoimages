#!/bin/bash
set -e

echo "Starting logstash..."
docker run --restart=always -d --network monitoring --name logstash \
-v /root/pipeline/:/usr/share/logstash/pipeline/ \
docker.elastic.co/logstash/logstash:5.3.0

echo "Starting logspout..."
docker service create --network monitoring --mode global --name logspout \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e "INACTIVITY_TIMEOUT=1m" \
gliderlabs/logspout tcp://10.0.4.11:7778?filter.name=*java*
