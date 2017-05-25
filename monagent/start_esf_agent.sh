#!/bin/bash
set -e

docker service create --network percona-dc1 --network percona-dc2 --network percona-dc3 --name monagent --log-opt max-size=10m --log-opt max-file=10 \
--mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
-e "DNS_ADDRS=mysql:percona_dc1:3306,mysql:percona_dc2:3306,mysql:percona_dc3:3306" \
-e "MYSQL_ROOT_PASSWORD=PassWord123" \
man4j/monagent:v1
