#!/usr/bin/env sh
# Drush cache rebuild.
$DRUSH cr
/scripts/flushRedisCache.sh
