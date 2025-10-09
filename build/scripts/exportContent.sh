#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

echo "Exporting content to $1"

echo "(Optionally) Creating files directory..."
mkdir -p "$1"

OUTPUT_FILE="$1/db.sql"
echo "Exporting database to $OUTPUT_FILE.gz"
echo "This may take a while..."
echo "Clearing Drupal cache..."
/scripts/clearDrupalCache.sh > /dev/null 2>&1
echo "Dumping database..."
/scripts/sqlDump.sh "$OUTPUT_FILE"
gzip -f "$OUTPUT_FILE"
echo "$OUTPUT_FILE.gz"
