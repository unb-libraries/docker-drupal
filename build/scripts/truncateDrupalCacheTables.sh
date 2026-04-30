#!/usr/bin/env sh
set -e
#
# Forcibly truncate all cache tables.
# Use sql:connect (returns a mysql connect string) instead of piping to
# sql:cli — drush warns that stdin to sql:cli is slow.
SQL_CONN=$($DRUSH sql:connect)
SQL=$($DRUSH sql:query "SELECT CONCAT('TRUNCATE TABLE \`', table_name, '\`;') FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name LIKE 'cache\\_%';")
if [ -n "$SQL" ]; then
  printf '%s\n' "$SQL" | $SQL_CONN
  echo "Tables Truncated!"
fi
