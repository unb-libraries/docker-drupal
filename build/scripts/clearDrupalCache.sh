#!/usr/bin/env sh
SQL_CONN=$($DRUSH sql-connect)
echo "SHOW TABLES LIKE 'cache%'" | $SQL_CONN | tail -n +2 | xargs -n1 -I% echo "TRUNCATE TABLE %;" | $SQL_CONN
echo "Drupal Cache Tables Truncated."
$DRUSH cr
