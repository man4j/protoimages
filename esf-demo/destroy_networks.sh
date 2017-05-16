#!/bin/bash
set +e

dc_count=$1

docker network rm esf-net

for ((i=1;i<=$dc_count;i++)) do
  docker network rm percona-dc${i}
  docker network rm web-dc${i}
done