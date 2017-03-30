FROM percona/percona-server:5.7.17

USER root

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh 

COPY mysqlchk /etc/xinetd.d/

COPY slavecheck /usr/bin
RUN chmod +x /usr/bin/slavecheck

RUN apt-get update \
&& apt-get install -y xinetd \
&& apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y --force-yes percona-toolkit \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
