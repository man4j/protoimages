#!/bin/bash
set -e

echo "Starting logstash..."
docker run --restart=always -d --network monitoring --name logstash \
-v /root/elk/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
docker.elastic.co/logstash/logstash:5.3.0
