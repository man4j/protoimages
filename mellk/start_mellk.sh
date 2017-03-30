#!/bin/bash
set -e

echo "Starting elasticsearch..."
docker run --restart=always -d --network monitoring --name elasticsearch \
--cap-add=IPC_LOCK --ulimit memlock=-1:-1 --ulimit nofile=65536:65536 --memory="1g" --memory-swap="1g" --memory-swappiness=0 \
-e "http.host=0.0.0.0" \
-e "transport.host=127.0.0.1" \
-e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
-e "bootstrap.memory_lock=true" \
-e "LOGSPOUT=ignore" \
docker.elastic.co/elasticsearch/elasticsearch:5.3.0

echo "Waiting 180s..."
sleep 180

echo "Starting logstash..."
docker run --restart=always -d --network monitoring --name logstash \
-v /root/pipeline/:/usr/share/logstash/pipeline/ \
docker.elastic.co/logstash/logstash:5.3.0

echo "Starting kibana..."
docker run --restart=always -d --network monitoring -p 5601:5601 --name kibana \
-e "ELASTICSEARCH_URL=http://elasticsearch:9200" \
docker.elastic.co/kibana/kibana:5.3.0

echo "Starting logspout..."
docker service create --network monitoring --mode global --name logspout \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e INACTIVITY_TIMEOUT=1m \
gliderlabs/logspout tcp://logstash:7778?filter.name=*java*

echo "Starting metricbeat..."
docker service create --network monitoring --name=metricbeat --pid=host --mode global \
-e ELASTICSEARCH_URL=http://elasticsearch:9200 \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
--mount "type=bind,source=/proc,target=/hostfs/proc:ro" \
--mount "type=bind,source=/sys/fs/cgroup,target=/hostfs/sys/fs/cgroup:ro" \
--mount "type=bind,source=/,target=/hostfs:ro" \
man4j/metricbeat:5.3.0_1 -system.hostfs=/hostfs
