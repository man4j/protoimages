#!/bin/bash
set -e

dc_count=$1

docker network create --driver overlay --attachable --subnet=100.0.0.0/24 esf-net

for ((i=1;i<=$dc_count;i++)) do
  docker network create --driver overlay --attachable --subnet=${i}.0.1.0/24 percona-dc${i}
  docker network create --driver overlay --attachable --subnet=${i}.0.2.0/24 web-dc${i}
done