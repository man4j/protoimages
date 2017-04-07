#!/bin/bash
set -e

docker service create --network dc1 --network dc2 --network dc3 --name monitoring_java_agent --log-opt max-size=100m --log-opt max-file=5 \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e "DNS_ADDRS=mysql:tasks.galera_dc1:3306,mysql:tasks.galera_dc2:3306,mysql:tasks.galera_dc3:3306,mysql:tasks.slave_dc1:3307,mysql:tasks.slave_dc2:3307,mysql:tasks.slave_dc3:3307,haproxy:tasks.haproxy_dc1:14567,haproxy:tasks.haproxy_dc2:14567,haproxy:tasks.haproxy_dc3:14567" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
man4j/monitoring_java_agent:v11
