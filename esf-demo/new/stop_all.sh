#!/bin/bash
set +e

dc_count=3

./stop_web.sh ${dc_count}
./stop_percona.sh ${dc_count}
./stop_kafka.sh ${dc_count}
./stop_voltdb.sh ${dc_count}
./destroy_networks.sh ${dc_count}
