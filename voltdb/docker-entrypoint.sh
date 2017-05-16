#!/bin/bash

set -e

function init() {
  if [ -f  ${CUSTOM_CONFIG} ]; then
    DEPLOYMENT=${CUSTOM_CONFIG}
  else
    DEPLOYMENT=${DEFAULT_DEPLOYMENT}
  fi

  OPTIONS="-C ${DEPLOYMENT} -D ${DIRECTORY_SPEC}"

  echo "Run voltdb init $OPTIONS"

  bin/voltdb init ${OPTIONS}

  firstRun=1
}

function execVoltdbStart() {
  if [ -z "${HOST_COUNT}" ] && [ -z "${HOSTS}" ]; then
    echo "To start a Volt cluster, atleast need to provide HOST_COUNT OR list of HOSTS"
    exit
  fi

  if [ -n "${HOST_COUNT}" ]; then
    OPTIONS1=" -c $HOST_COUNT"
  fi

  if [ -n "${HOSTS}" ]; then
    OPTIONS1="$OPTIONS1 -H $HOSTS"
  fi

  if [ -n "${DIRECTORY_SPEC}" ]; then
    OPTIONS1="$OPTIONS1 -D ${DIRECTORY_SPEC}"
  fi

  if [ -f ${LICENSE_FILE} ]; then
    OPTIONS1="$OPTIONS1 -l ${LICENSE_FILE}"
  fi

  OPTIONS1="$OPTIONS1 --ignore=thp"

  echo "Run voltdb start $OPTIONS1"
  bin/voltdb start $OPTIONS1 &

  pid="$!"

  if [[ $HOST_NUM == 1 && $firstRun == 1 ]]; then
    echo "Starting voltdb schema initialization..."
    while true; do
      if ! kill -0 $pid > /dev/null 2>&1; then
        echo >&2 'VoltDb init process failed.'
        exit 1
      fi

      if sqlcmd --query="exec @Statistics PARTITIONCOUNT 0;" ; then
        break
      fi
      echo 'VoltDb init process in progress...'
      sleep 1
    done

    /post_init.sh
  fi

  wait "$pid"
}

if [ ! -f ${DIRECTORY_SPEC}/voltdbroot/.initialized ]; then
  init
fi

execVoltdbStart