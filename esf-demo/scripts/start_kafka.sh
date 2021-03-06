#!/bin/bash

set -e

dc_count=$1
constr=$2

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

echo "Creating a cross datacenter kafka network: [kafka-net]"
set +e
docker network create --driver overlay --attachable --subnet=102.0.0.0/24 kafka-net
set -e

zoo_servers=server.1=zookeeper_dc1:2888:3888
zoo_connect=zookeeper_dc1:2181

for ((i=2;i<=$dc_count;i++)) do
  zoo_servers=${zoo_servers}" server.${i}=zookeeper_dc${i}:2888:3888"
  zoo_connect=${zoo_connect},zookeeper_dc${i}:2181
done

echo "zoo_servers:" ${zoo_servers}
echo "zoo_connect:" ${zoo_connect}

for ((i=1;i<=$dc_count;i++)) do

echo "Starting zookeeper with constraint: ${constr:-dc${i}}..."

docker service create --detach=false --network kafka-net --endpoint-mode dnsrr --name zookeeper_dc${i} --constraint "engine.labels.dc == ${constr:-dc${i}}" \
--mount "type=volume,source=zookeeper_data_volume${i},target=/data" \
--mount "type=volume,source=zookeeper_datalog_volume${i},target=/datalog" \
-e "ZOO_MY_ID=${i}" \
-e "JMXPORT=9099" \
-e "ZOO_SERVERS=${zoo_servers}" \
zookeeper:3.4.10

echo "Success. Waiting 30s..."
sleep 30

done


for ((i=1;i<=$dc_count;i++)) do

echo "Starting kafka with constraint: ${constr:-dc${i}}..."

if [[ $i == $dc_count ]]; then
  echo "Enable auto create topics in dc${i}"
  createTopics=ESF.VALID:12:2 #only on last node
fi

docker service create --detach=false --network kafka-net --endpoint-mode dnsrr --name kafka_dc${i} --constraint "engine.labels.dc == ${constr:-dc${i}}" \
--mount "type=volume,source=kafka_volume${i},target=/kafka" \
-e "KAFKA_ADVERTISED_HOST_NAME=kafka_dc${i}" \
-e "KAFKA_ADVERTISED_PORT=9092" \
-e "KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS=10" \
-e "KAFKA_BROKER_ID=${i}" \
-e "KAFKA_ZOOKEEPER_CONNECT=${zoo_connect}" \
-e "KAFKA_MESSAGE_MAX_BYTES=10485760" \
-e "KAFKA_REPLICA_FETCH_MAX_BYTES=10485760" \
-e "KAFKA_CREATE_TOPICS=${createTopics}" \
-e "KAFKA_AUTO_CREATE_TOPICS_ENABLE=false" \
-e "KAFKA_PORT=9092" \
wurstmeister/kafka:0.10.2.0

echo "Success. Waiting 30s..."
sleep 30

done
