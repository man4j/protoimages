#!/bin/bash
set +e

dc_count=$1

for ((i=1;i<=$dc_count;i++)) do
  docker service rm voltdb${i}
  docker service rm nginx-voltdb${i}
done

