#!/bin/bash

set -e

dc_count=3

hosts=voltdb1

for ((i=2;i<=$dc_count;i++)) do
  hosts=${hosts},voltdb${i}
done

echo "Hosts:" ${hosts}

for ((i=1;i<=$dc_count;i++)) do

echo "Starting voltdb${i}..."

docker service create --network skynet --endpoint-mode dnsrr \
-e "HOST_COUNT=${dc_count}" \
-e "HOSTS=${hosts}" \
--mount "type=bind,source=/root,target=/var/voltdb" \
--name voltdb${i} --constraint "node.labels.dc == dc${i}" \
man4j/elastic_voltdb:6.9.2_7

docker service create -p 804${i}:8080 --network skynet --name nginx-voltdb${i} \
-e "WEB_USER=man4j" \
-e "WEB_PASSWORD=PassWord123" \
-e "APP_URL=http://voltdb${i}:8080" \
--constraint "node.labels.dc == dc${i}" \
man4j/nginx-protect:2

sleep 60
echo "Success"

done
