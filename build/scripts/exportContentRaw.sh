#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

mkdir -p "$1"

# Raw content export: dump the database without first clearing the cache. No
# wrapper steps - intended for callers that do not want side effects on the
# running site.
OUTPUT_FILE="$1/db.sql"
/scripts/sqlDump.sh "$OUTPUT_FILE"
gzip -f "$OUTPUT_FILE"
echo "$OUTPUT_FILE.gz"
