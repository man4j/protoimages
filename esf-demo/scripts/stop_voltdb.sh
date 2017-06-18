#!/bin/bash
set +e

dc_count=$1

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

for ((i=1;i<=$dc_count;i++)) do
  docker service rm voltdb${i}
  docker service rm nginx-voltdb${i}
done

