#!/bin/bash
set -e

dc_count=$1
single=$2

./create_networks.sh ${dc_count} ${single}

./start_web.sh ${dc_count} ${single} &
web_pid="$!"

./start_percona.sh ${dc_count} 10 ${single} &
percona_pid="$!"

./start_kafka.sh ${dc_count} ${single} &
kafka_pid="$!"

./start_voltdb.sh ${dc_count} ${single} &
voltdb_pid="$!"

echo "Waiting web..."
wait "$web_pid"

echo "Waiting percona..."
wait "$percona_pid"

echo "Waiting kafka..."
wait "$kafka_pid"

echo "Waiting voltdb..."
wait "$voltdb_pid"