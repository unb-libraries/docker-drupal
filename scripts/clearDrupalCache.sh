#!/usr/bin/env sh
echo "SHOW TABLES LIKE 'cache%'" | $(drush sql-connect) | tail -n +2 | xargs -n1 -I% echo "TRUNCATE TABLE %;" | $(drush sql-connect)
echo "Drupal Cache Tables Truncated."
