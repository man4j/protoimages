#!/bin/bash
set -e

echo "Loading classes..."
sqlcmd --query="load classes /esf.jar;"

echo "Loading SQL schema..."
sqlcmd < /ddl.sql

echo "Loading test data..."
sqlcmd < /init-database.sql

echo "Done."