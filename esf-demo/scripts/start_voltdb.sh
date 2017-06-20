#!/bin/bash

set -e

dc_count=$1
constr=$2

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

echo "Creating a cross datacenter voltdb network: [voltdb-net]"
set +e
docker network create --driver overlay --attachable --subnet=101.0.0.0/24 voltdb-net
set -e

hosts=voltdb_dc1

for ((i=2;i<=$dc_count;i++)) do
  hosts=${hosts},voltdb_dc${i}
done

echo "Hosts:" ${hosts}

for ((i=1;i<=$dc_count;i++)) do
  echo "Starting voltdb with constraint: ${constr:-dc${i}}..."
  docker service create --detach=false --network voltdb-net --endpoint-mode dnsrr --name voltdb_dc${i} --constraint "engine.labels.dc == ${constr:-dc${i}}" \
-e "HOST_COUNT=${dc_count}" \
-e "HOST_NUM=${i}" \
-e "HOSTS=${hosts}" \
--mount "type=volume,source=voltdb_volume${i},target=/var/voltdb" \
man4j/esf_voltdb:6.9.2_1

  echo "Starting nginx-voltdb with constraint: ${constr:-dc${i}}..."

  docker service create --detach=false -p 804${i}:8080 --network voltdb-net --name nginx_voltdb_dc${i} --constraint "engine.labels.dc == ${constr:-dc${i}}" \
-e "WEB_USER=man4j" \
-e "WEB_PASSWORD=PassWord123" \
-e "APP_URL=http://voltdb_dc${i}:8080" \
man4j/nginx-protect:2

  echo "Success. Waiting 60s..."
  sleep 60
done
