#!/bin/bash
set -e

dc_count=$1
single=$2

./create_networks.sh ${dc_count} ${single}
./start_haproxy.sh ${dc_count} ${single}
./start_percona.sh ${dc_count} ${single}
./start_kafka.sh ${dc_count} ${single}
./start_voltdb.sh ${dc_count} ${single}
./start_web.sh ${dc_count} ${single}