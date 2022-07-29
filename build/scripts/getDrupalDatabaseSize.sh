#!/usr/bin/env sh
DB_NAME=$(/scripts/getDrupalDatabase.sh)
$DRUSH sqlq "SELECT SUM(data_length + index_length) FROM information_schema.TABLES WHERE table_schema='$DB_NAME'" | tr -d '\n'
