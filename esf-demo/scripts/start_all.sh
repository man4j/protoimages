#!/bin/bash
set -e

dc_count=$1
single=$2

if [ -z "$1" ]; then
 echo "ERROR: Param dc_count not specified"
fi

echo ""
echo ""
echo " _____                                            _"
echo "|_   _|                                          (_)"
echo "  | | _ __ ___   __ _  __ _  ___ _ __   __ _ _ __ _ _   _ _ __ ___"
echo "  | ||  _   _ \ / _  |/ _  |/ _ \  _ \ / _  |  __| | | | |  _   _ \ "
echo " _| || | | | | | (_| | (_| |  __/ | | | (_| | |  | | |_| | | | | | |"
echo " \___/_| |_| |_|\__ _|\__  |\___|_| |_|\__ _|_|  |_|\__ _|_| |_| |_|"
echo "                       __/ |"
echo "                      |___/"
echo ""
echo "| E | l | e | c | t | r | o | n | i | c |   | I | n | v | o | i | c | e   | S | y | s | t | e | m |"
echo ""
echo ""

./create_networks.sh ${dc_count} ${single} > /tmp/network.log 2>&1

./start_web.sh ${dc_count} ${single} > /tmp/web.log 2>&1 &
web_pid="$!"

./start_percona.sh ${dc_count} 10 ${single} > /tmp/percona.log 2>&1 &
percona_pid="$!"

./start_kafka.sh ${dc_count} ${single} > /tmp/kafka.log 2>&1 &
kafka_pid="$!"

./start_voltdb.sh ${dc_count} ${single} > /tmp/voltdb.log 2>&1 &
voltdb_pid="$!"

echo "Waiting web..."
wait "$web_pid"

echo "Waiting percona..."
wait "$percona_pid"

echo "Waiting kafka..."
wait "$kafka_pid"

echo "Waiting voltdb..."
wait "$voltdb_pid"

echo "Success"