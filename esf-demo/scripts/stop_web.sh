#!/bin/bash
set +e

dc_count=$1

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

for ((i=1;i<=$dc_count;i++)) do
  docker service rm esf-web_dc${i}
  docker service rm web_proxy_dc${i}
done

