#!/usr/bin/env sh
$DRUSH cr
/scripts/truncateDrupalCacheTables.sh
/scripts/flushRedisCache.sh
