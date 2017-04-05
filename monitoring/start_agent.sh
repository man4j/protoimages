#!/bin/bash
set -e

docker service create --network monitoring --name monitoring_java_agent --log-opt max-size=100m --log-opt max-file=5 \
-e "MYSQL_DNS_ADDRS=tasks.galera_dc1:3306,tasks.galera_dc2:3306,tasks.galera_dc3:3306,tasks.slave_dc1:3307,tasks.slave_dc2:3307,tasks.slave_dc3:3307" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
man4j/monitoring_java_agent:v7
