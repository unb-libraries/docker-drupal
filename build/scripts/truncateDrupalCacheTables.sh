#!/usr/bin/env sh
set -e
#
# Forcibly truncate all cache tables.
SQL=$($DRUSH sql:query "SELECT CONCAT('TRUNCATE TABLE \`', table_name, '\`;') FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name LIKE 'cache\\_%';")
if [ -n "$SQL" ]; then
  printf '%s\n' "$SQL" | $DRUSH sql:cli
  echo "Tables Truncated!"
fi
