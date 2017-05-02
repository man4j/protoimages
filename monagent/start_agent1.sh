#!/bin/bash
set -e

docker service create --network dc1 --network dc2 --network dc3 --name monagent --log-opt max-size=10m --log-opt max-file=10 \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e "DNS_ADDRS=mysql:galera_dc1:3306,mysql:galera_dc2:3306,mysql:galera_dc3:3306,haproxy:haproxy_dc1:14567,haproxy:haproxy_dc2:14567,haproxy:haproxy_dc3:14567" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
man4j/monagent:v1
