#!/usr/bin/env sh
/scripts/removeAggregatedCssJs.sh
/scripts/truncateDrupalCacheTables.sh
/scripts/flushRedisCache.sh
$DRUSH cr
