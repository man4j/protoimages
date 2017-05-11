FROM ubuntu:16.04

RUN set -e

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
                                   apt-get upgrade -y && \
                                   apt-get -y  --no-install-recommends --no-install-suggests install python-software-properties && \
                                   apt-get -y  --no-install-recommends --no-install-suggests install software-properties-common

RUN add-apt-repository -y  ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y  --no-install-recommends --no-install-suggests openjdk-8-jdk wget 


ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

EXPOSE 22 3021 5555 7181 8080 8081 9000 21211 21212

ENV VOLTDB_DIST=/opt/voltdb
ENV PATH=$PATH:$VOLTDB_DIST/bin

ARG VOLT_KIT_VERSION=ent-6.9.2
ARG VOLT_DIR_SUFFIX=${VOLT_KIT_VERSION}

COPY voltdb-${VOLT_KIT_VERSION}.tar.gz .

RUN tar -zxf voltdb-${VOLT_KIT_VERSION}.tar.gz && \
    mkdir ${VOLTDB_DIST} && \
    cp -r voltdb-${VOLT_DIR_SUFFIX}/* $VOLTDB_DIST && \
    rm -r voltdb-${VOLT_DIR_SUFFIX} voltdb-${VOLT_KIT_VERSION}.tar.gz

WORKDIR $VOLTDB_DIST

COPY deployment.xml ${VOLTDB_DIST}
COPY license.xml ${VOLTDB_DIST}/voltdb

ENV DEFAULT_DEPLOYMENT=$VOLTDB_DIST/deployment.xml
ENV CUSTOM_CONFIG=/tmp/deployment.xml
ENV LICENSE_FILE=/tmp/license.xml
ENV DIRECTORY_SPEC=/var/voltdb/

RUN mkdir $DIRECTORY_SPEC

COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

COPY esf.jar /

VOLUME /var/voltdb

ENTRYPOINT ["./docker-entrypoint.sh"]