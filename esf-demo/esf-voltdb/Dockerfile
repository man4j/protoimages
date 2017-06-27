FROM man4j/elastic_voltdb:6.9.2_12

COPY esf.jar /
COPY ddl.sql /
COPY init-database.sql /
COPY post_init.sh /

RUN chmod +x /post_init.sh