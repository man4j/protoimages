#!/bin/bash
set +e

dc_count=$1

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

./stop_web.sh ${dc_count}
./stop_percona.sh ${dc_count}
./stop_kafka.sh ${dc_count}
./stop_voltdb.sh ${dc_count}
./destroy_networks.sh ${dc_count}
