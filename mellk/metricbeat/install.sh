#!/bin/bash
set -e

METRICBEAT_VERSION=5.3.0

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${METRICBEAT_VERSION}-linux-x86_64.tar.gz && \
tar -xvvf metricbeat-${METRICBEAT_VERSION}-linux-x86_64.tar.gz && \
mv metricbeat-${METRICBEAT_VERSION}-linux-x86_64/ /opt/metricbeat && \
cp ./metricbeat.yml /opt/metricbeat/metricbeat.example.yml && \
mv /opt/metricbeat/metricbeat /bin/metricbeat && \
chmod +x /bin/metricbeat && \
mkdir -p /opt/metricbeat/config /opt/metricbeat/data && \
rm metricbeat-${METRICBEAT_VERSION}-linux-x86_64.tar.gz && \
cp ./metricbeat.yml /opt/metricbeat/

