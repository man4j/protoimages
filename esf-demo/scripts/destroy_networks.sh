#!/bin/bash
set +e

dc_count=$1

docker network rm percona-net
docker network rm voltdb-net
docker network rm kafka-net

for ((i=1;i<=$dc_count;i++)) do
  docker network rm percona-dc${i}
done