#!/bin/bash
set -e

docker service create --network dc1 --network dc2 --network dc3 --mode global --name monitoring_java_agent --log-opt max-size=10m --log-opt max-file=10 \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e "PATTERNS=galera" \
man4j/logsextractor:v1
