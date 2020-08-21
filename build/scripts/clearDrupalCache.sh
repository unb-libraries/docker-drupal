#!/usr/bin/env sh
# Manually flush DB tables.
echo "SHOW TABLES LIKE 'cache%'" | $(drush sql-connect) | tail -n +2 | xargs -n1 -I% echo "TRUNCATE TABLE %;" | $(drush sql-connect)
echo "Drupal Cache Tables Truncated."

# Flush redis cache.
/scripts/flushRedisCache.sh

# Drush cache rebuild.
$DRUSH cr
