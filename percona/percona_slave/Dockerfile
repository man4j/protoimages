FROM percona/percona-server:5.7.16

USER root

COPY entrypoint.sh /
COPY percona_common/init_datadir.sh /init_datadir.sh
COPY percona_common/wait_mysql.sh /wait_mysql.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /init_datadir.sh
RUN chmod +x /wait_mysql.sh

COPY mysqlchk /etc/xinetd.d/

COPY slavecheck /usr/bin
RUN chmod +x /usr/bin/slavecheck

RUN apt-get update \
&& apt-get install -y xinetd \
&& apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y --force-yes percona-toolkit \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER 1001