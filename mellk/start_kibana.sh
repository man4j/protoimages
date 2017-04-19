#!/bin/bash
set -e

echo "Starting kibana..."
docker run --restart=always -d --network monitoring -p 5601:5601 --name kibana \
-v /root/elk/kibana.yml:/usr/share/kibana/config/kibana.yml \
docker.elastic.co/kibana/kibana:5.3.0
