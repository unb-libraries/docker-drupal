#!/usr/bin/env sh
set -e
/scripts/removeAggregatedCssJs.sh &
/scripts/truncateDrupalCacheTables.sh &
/scripts/flushRedisCache.sh &
wait
$DRUSH cr
