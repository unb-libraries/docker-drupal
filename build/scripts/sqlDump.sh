#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target specified."
  exit 1
fi
ls -al /snapshot
find /snapshot
$DRUSH sql-dump --debug --extra-dump=--no-tablespaces --structure-tables-list="accesslog,batch,cache,cache_*,ctools_css_cache,ctools_object_cache,flood,search_*,history,queue,semaphore,sessions,watchdog" --result-file=$1
