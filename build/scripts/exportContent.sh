#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

mkdir -p "$1"

OUTPUT_FILE="$1/db.sql"
/scripts/clearDrupalCache.sh > /dev/null 2>&1
/scripts/sqlDump.sh "$OUTPUT_FILE"
gzip -f "$OUTPUT_FILE"
echo "$OUTPUT_FILE.gz"
