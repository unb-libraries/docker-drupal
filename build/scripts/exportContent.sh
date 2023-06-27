#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

mkdir -p "$1"

OUTPUT_FILE="$1/db.sql.gz"
/scripts/clearDrupalCache.sh
$DRUSH sql-dump --extra-dump=--no-tablespaces --structure-tables-list="accesslog,batch,cache,cache_*,ctools_css_cache,ctools_object_cache,flood,search_*,history,queue,semaphore,sessions,watchdog" --result-file=$OUTPUT_FILE
echo "$OUTPUT_FILE"
