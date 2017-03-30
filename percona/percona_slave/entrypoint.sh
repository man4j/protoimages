#!/bin/bash
set -e

USER_ID=$(id -u)

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
CMDARG="$@"
fi
# comment out log output in my.cnf

if [ -n "$INIT_TOKUDB" ]; then
export LD_PRELOAD=/lib64/libjemalloc.so.1
fi
# Get config
DATADIR="$("mysqld" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

if [ ! -d "$DATADIR/mysql" ]; then
if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
                        echo >&2 'error: database is uninitialized and password option is not specified '
                        echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD'
                        exit 1
                fi
mkdir -p "$DATADIR"

echo "Running --initialize-insecure datadir: $DATADIR"
sudo -u mysql mysqld --no-defaults --initialize-insecure --datadir="$DATADIR"
echo 'Finished --initialize-insecure'

sudo -u mysql mysqld --no-defaults --datadir="$DATADIR" --skip-networking &
pid="$!"

mysql=( mysql --protocol=socket -uroot )

for i in {3000..0}; do
if echo 'SELECT 1' | "${mysql[@]}" ; then
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
# install TokuDB engine
if [ -n "$INIT_TOKUDB" ]; then
ps_tokudb_admin --force-mycnf --enable
fi

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

#My Patch#############################################

#get server_id from ip address
ipaddr=$(hostname -i | awk ' { print $1 } ')
server_id=$(echo $ipaddr | tr . '\n' | awk '{s = s*256 + $1} END {print s}')

if [ -z "$MYSQL_PORT" ]; then
  MYSQL_PORT=3306
fi

sudo -u mysql mysqld \
--port=$MYSQL_PORT \
--user=mysql \
--read_only=ON \
\
--server-id=$server_id \
--gtid-mode=ON \
--enforce-gtid-consistency \
--log-slave-updates=1 \
--log-bin=/var/log/mysql/mysqlbinlog \
--master-info-repository=TABLE \
--relay-log-info-repository=TABLE \
--slave-preserve-commit-order=1 \
--slave-parallel-workers=8 \
--slave-parallel-type=LOGICAL_CLOCK \
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

#mysql -u root -p${MYSQL_ROOT_PASSWORD} -h $MASTER_HOST -P $MASTER_PORT -e "SET GLOBAL read_only=1;"

echo "Checking Percona XtraDB Cluster Node status..."

MYSQL_MASTER_CMDLINE="mysql -u root -p${MYSQL_MASTER_ROOT_PASSWORD} -h ${MASTER_HOST} -P ${MASTER_PORT} -nNE --connect-timeout=5"

WSREP_STATUS=$($MYSQL_MASTER_CMDLINE -e "SHOW STATUS LIKE 'wsrep_local_state';" 2>/dev/null | tail -1 2>>/dev/null)

if [ "${WSREP_STATUS}" == "4" ]; then
  READ_ONLY=$($MYSQL_MASTER_CMDLINE -e "SHOW GLOBAL VARIABLES LIKE 'read_only';" 2>/dev/null | tail -1 2>>/dev/null)
        
  if [ "${READ_ONLY}" == "ON" ]; then
    echo "Percona XtraDB Cluster Node is read-only"
    exit 1
  fi
else
    echo "Percona XtraDB Cluster Node is not synced. Status is: ${WSREP_STATUS}"
    exit 1
fi

echo "Percona XtraDB Cluster Node status is: ${WSREP_STATUS}"

mysqldump \
  --protocol=tcp \
  --user=root \
  --password=$MYSQL_MASTER_ROOT_PASSWORD \
  --host=$MASTER_HOST \
  --port=$MASTER_PORT \
  --all-databases \
  --triggers \
  --routines \
  --events \
  --add-drop-database \
  --single-transaction \
  | mysql -u root -p${MYSQL_ROOT_PASSWORD} -h 127.0.0.1 -P ${MYSQL_PORT}

#mysql -u root -p${MYSQL_ROOT_PASSWORD} -h $MASTER_HOST -P $MASTER_PORT -e "SET GLOBAL read_only=0;"

echo "Slave initialized, connecting to master..."

mysql -u root -p${MYSQL_ROOT_PASSWORD} -h 127.0.0.1 -P ${MYSQL_PORT} -e "CHANGE MASTER TO MASTER_HOST='${MASTER_HOST}', MASTER_USER='root', MASTER_PASSWORD='${MYSQL_MASTER_ROOT_PASSWORD}', MASTER_AUTO_POSITION = 1; START SLAVE;"

/etc/init.d/xinetd start

wait "$pid"
