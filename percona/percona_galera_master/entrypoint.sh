#!/bin/bash
set -e

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
CMDARG="$@"
fi

if [ -z "$CLUSTER_NAME" ]; then
echo >&2 'Error:  You need to specify CLUSTER_NAME'
exit 1
fi

# Get config
DATADIR="$("mysqld" --verbose --wsrep_provider= --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

if [ ! -e "$DATADIR/init.ok" ]; then
if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
                        echo >&2 'error: database is uninitialized and password option is not specified '
                        echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD'
                        exit 1
                fi
mkdir -p "$DATADIR"

echo "Running --initialize-insecure on $DATADIR"
ls -lah $DATADIR
mysqld --initialize-insecure
chown -R mysql:mysql "$DATADIR"
chown mysql:mysql /var/log/mysqld.log
echo 'Finished --initialize-insecure'

mysqld --user=mysql --datadir="$DATADIR" --skip-networking &
pid="$!"

mysql=( mysql --protocol=socket -uroot )

for i in {30..0}; do
if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
break
fi
echo 'MySQL init process in progress...'
sleep 1
done
if [ "$i" = 0 ]; then
echo >&2 'MySQL init process failed.'
exit 1
fi

# sed is for https://bugs.mysql.com/bug.php?id=20545
mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | "${mysql[@]}" mysql
if [ ! -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
MYSQL_ROOT_PASSWORD="$(pwmake 128)"
echo "GENERATED ROOT PASSWORD: $MYSQL_ROOT_PASSWORD"
fi
"${mysql[@]}" <<-EOSQL
-- What's done in this file shouldn't be replicated
--  or products like mysql-fabric won't work
SET @@SESSION.SQL_LOG_BIN=0;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
CREATE USER 'xtrabackup'@'localhost' IDENTIFIED BY '$XTRABACKUP_PASSWORD';
GRANT RELOAD,PROCESS,LOCK TABLES,REPLICATION CLIENT ON *.* TO 'xtrabackup'@'localhost';
GRANT REPLICATION CLIENT ON *.* TO monitor@'%' IDENTIFIED BY 'monitor';
GRANT PROCESS ON *.* TO monitor@localhost IDENTIFIED BY 'monitor';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOSQL

if [ "$MYSQL_DATABASE" ]; then
echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
mysql+=( "$MYSQL_DATABASE" )
fi

if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
echo "CREATE USER '"$MYSQL_USER"'@'%' IDENTIFIED BY '"$MYSQL_PASSWORD"' ;" | "${mysql[@]}"

if [ "$MYSQL_DATABASE" ]; then
echo "GRANT ALL ON \`"$MYSQL_DATABASE"\`.* TO '"$MYSQL_USER"'@'%' ;" | "${mysql[@]}"
fi

echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
fi

if [ ! -z "$MYSQL_ONETIME_PASSWORD" ]; then
"${mysql[@]}" <<-EOSQL
ALTER USER 'root'@'%' PASSWORD EXPIRE;
EOSQL
fi
if ! kill -s TERM "$pid" || ! wait "$pid"; then
echo >&2 'MySQL init process failed.'
exit 1
fi

echo
echo 'MySQL init process done. Ready for start up.'
echo
#mv /etc/my.cnf $DATADIR
fi
touch $DATADIR/init.ok
chown -R mysql:mysql "$DATADIR"

cluster_join=$CLUSTER_JOIN

#My Patch=============================================================================
if [ -z "$NETMASK" ]; then
  ipaddr=$(hostname -i | awk ' { print $1 } ')
else
  ipaddr=$(hostname -i |  tr ' ' '\n' | awk -vm=$NETMASK '$1 ~ m { print $1; exit }')
fi

server_id=$(echo $ipaddr | tr . '\n' | awk '{s = s*256 + $1} END {print s}')

if [ -z "$MYSQL_PORT" ]; then
  MYSQL_PORT=3306
fi

if [ -z "$GMCAST_SEGMENT" ]; then
  GMCAST_SEGMENT=0
fi

mysqld \
--user=mysql \
--port=${MYSQL_PORT} \
\
--wsrep_provider_options="gmcast.segment=$GMCAST_SEGMENT; evs.send_window=512; evs.user_send_window=512;" \
--wsrep_cluster_name=$CLUSTER_NAME \
--wsrep_cluster_address="gcomm://$cluster_join" \
--wsrep_node_address="$ipaddr" \
--wsrep_sst_method=xtrabackup-v2 \
--wsrep_sst_auth="xtrabackup:$XTRABACKUP_PASSWORD" \
\
--server-id=$server_id \
--gtid-mode=ON \
--enforce-gtid-consistency \
--log-bin=/var/log/mysql/mysqlbinlog \
--log-slave-updates=1 \
--expire-logs-days=7 \
\
--log-output=file \
--slow-query-log=ON \
--long-query-time=0 \
--log-slow-rate-limit=100 \
--log-slow-rate-type=query \
--log-slow-verbosity=full \
--log-slow-admin-statements=ON \
--log-slow-slave-statements=ON \
--slow-query-log-always-write-time=1 \
--slow-query-log-use-global-control=all \
--innodb-monitor-enable=all \
--userstat=1 \
$CMDARG &

pid="$!"

echo "Started with PID $pid, waiting for starting..."

mysql=( mysql -u root -p${MYSQL_ROOT_PASSWORD} -h 127.0.0.1 -P ${MYSQL_PORT} )

while true; do
  if ! kill -0 $pid > /dev/null 2>&1; then
    echo >&2 'MySQL start process failed.'
    exit 1
  fi

  if echo 'SELECT 1' | "${mysql[@]}" ; then
    break
  fi
  echo 'MySQL start process in progress...'
  sleep 1
done

if [ "$i" = 0 ]; then
  echo >&2 'MySQL start process failed.'
  exit 1
fi

/etc/init.d/xinetd start

wait "$pid"
