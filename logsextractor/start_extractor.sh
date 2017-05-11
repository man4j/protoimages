#!/bin/bash
set -e

docker service create --network monitoring --mode global --name logsextractor --log-opt max-size=10m --log-opt max-file=10 \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e "PATTERNS=galera,monagent,esf-web" \
man4j/logsextractor:v2
