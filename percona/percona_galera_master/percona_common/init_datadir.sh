#!/bin/bash
set -e

# Get config
DATADIR="$("mysqld" --verbose --wsrep_provider= --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

if [ ! -e "$DATADIR/mysql" ]; then
  if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
    echo >&2 'error: database is uninitialized and password option is not specified '
    echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD'
    exit 1
  fi

  mkdir -p "$DATADIR"

  echo "Running --initialize-insecure on $DATADIR"
  mysqld --user=mysql --initialize-insecure
  echo 'Finished --initialize-insecure'

  mysqld --user=mysql --skip-networking &
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

  if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
    mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )
  fi

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
fi
