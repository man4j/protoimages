#!/bin/bash
set -e

dc_count=$1

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

docker network create --driver overlay --attachable --subnet=100.0.0.0/24 percona-net
docker network create --driver overlay --attachable --subnet=101.0.0.0/24 voltdb-net
docker network create --driver overlay --attachable --subnet=102.0.0.0/24 kafka-net

set +e
docker network create --driver overlay --attachable --subnet=77.77.77.0/24 monitoring
set -e

for ((i=1;i<=$dc_count;i++)) do
  docker network create --driver overlay --attachable --subnet=${i}.0.1.0/24 percona-dc${i}
done