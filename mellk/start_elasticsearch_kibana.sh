#!/bin/bash
set -e

echo "Starting elasticsearch..."
docker run --restart=always -d --network monitoring -p 9200:9200 --name elasticsearch \
--cap-add=IPC_LOCK --ulimit memlock=-1:-1 --ulimit nofile=65536:65536 --memory="1g" --memory-swap="1g" --memory-swappiness=0 \
-e "http.host=0.0.0.0" \
-e "transport.host=127.0.0.1" \
-e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
-e "bootstrap.memory_lock=true" \
-e "LOGSPOUT=ignore" \
docker.elastic.co/elasticsearch/elasticsearch:5.3.0

echo "Waiting 180s..."
sleep 180

echo "Starting kibana..."
docker run --restart=always -d --network monitoring -p 5601:5601 --name kibana \
-e "ELASTICSEARCH_URL=http://elasticsearch:9200" \
-e "ELASTICSEARCH_PASSWORD=changeme" \
docker.elastic.co/kibana/kibana:5.3.0
