#!/bin/bash

set -e

dc_count=$1
constr=$2

hosts=voltdb1

for ((i=2;i<=$dc_count;i++)) do
  hosts=${hosts},voltdb${i}
done

echo "Hosts:" ${hosts}

for ((i=1;i<=$dc_count;i++)) do

echo "Starting voltdb${i} with constraint: ${constr:-dc${i}}..."

docker service create --detach=false --network esf-net --endpoint-mode dnsrr \
-e "HOST_COUNT=${dc_count}" \
-e "HOST_NUM=${i}" \
-e "HOSTS=${hosts}" \
--mount "type=volume,source=voltdb_volume${i},target=/var/voltdb" \
--name voltdb${i} --constraint "node.labels.dc == ${constr:-dc${i}}" \
man4j/esf_voltdb:6.9.2_1

echo "Starting nginx-voltdb${i} with constraint: ${constr:-dc${i}}..."

docker service create --detach=false -p 804${i}:8080 --network esf-net --name nginx-voltdb${i} \
-e "WEB_USER=man4j" \
-e "WEB_PASSWORD=PassWord123" \
-e "APP_URL=http://voltdb${i}:8080" \
--constraint "node.labels.dc == ${constr:-dc${i}}" \
man4j/nginx-protect:2

echo "Success. Waiting 60s..."
sleep 60

done
