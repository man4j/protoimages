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

    if [ -n "${JOIN}" ]; then
        OPTIONS1="$OPTIONS1 --add"
    fi

    if [ -n "${DIRECTORY_SPEC}" ]; then
        OPTIONS1="$OPTIONS1 -D ${DIRECTORY_SPEC}"
    fi

    if [ -f ${LICENSE_FILE} ]; then
        OPTIONS1="$OPTIONS1 -l ${LICENSE_FILE}"
    fi

    OPTIONS1="$OPTIONS1 --ignore=thp"

    echo "Run voltdb start $OPTIONS1"
    exec bin/voltdb start $OPTIONS1
}

if [ ! -f ${DIRECTORY_SPEC}/voltdbroot/.initialized ]; then
    init
fi

execVoltdbStart