FROM man4j/percona_galera_master:5.7.16_5

COPY post_init.sh /
COPY percona.sql /

RUN chmod +x /post_init.sh
