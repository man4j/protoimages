#!/bin/bash
set -e

echo "Starting elasticsearch..."
docker run --restart=always -d --network monitoring --name elasticsearch \
--cap-add=IPC_LOCK --ulimit memlock=-1:-1 --ulimit nofile=65536:65536 --memory-swappiness=0 \
-v /root/elk/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v esdata:/usr/share/elasticsearch/data \
-e "http.host=0.0.0.0" \
-e "transport.host=127.0.0.1" \
-e "ES_JAVA_OPTS=-Xms1G -Xmx1G" \
-e "bootstrap.memory_lock=true" \
docker.elastic.co/elasticsearch/elasticsearch:5.3.0

