#!/bin/bash
set -e

dc_count=3

for ((i=1;i<=$dc_count;i++)) do
docker service rm haproxy_dc${i}
done