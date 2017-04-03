#!/bin/bash
set -e

docker service create --network monitoring --name galera_java_monitoring_agent --log-opt max-size=100m --log-opt max-file=5 \
-e "MYSQL_DNS_ADDRS=tasks.galera_dc1,tasks.galera_dc2,tasks.galera_dc3" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
man4j/monitoring_java_agent:v1
