#!/bin/bash
set -e

mysql=( mysql --protocol=socket -uroot )

echo "Init database schema..."

"${mysql[@]}" < percona.sql

echo "Done."