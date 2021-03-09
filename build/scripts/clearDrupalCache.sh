#!/usr/bin/env sh
/scripts/truncateDrupalCacheTables.sh
/scripts/flushRedisCache.sh
$DRUSH cr
