#!/bin/bash
set -e

dc_count=3

docker network create --driver overlay --attachable --subnet=10.0.0.0/16 skynet
docker network create --driver overlay --attachable --subnet=11.0.0.0/16 monitoring

for ((i=1;i<=$dc_count;i++)) do
  docker network create --driver overlay --attachable --subnet=10.${i}.0.0/16 dc${i}
done