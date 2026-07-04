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
# Compress and checksum in a single pass: gzip once, tee the compressed stream
# to disk while feeding it to sha256sum. pipefail (busybox ash) + set -e abort
# the snapshot if gzip fails, so a truncated archive is never stored.
set -o pipefail
gzip -c "$OUTPUT_FILE" | tee "$OUTPUT_FILE.gz" | sha256sum | cut -d' ' -f1 > "$OUTPUT_FILE.gz.sha256"
rm -f "$OUTPUT_FILE"
echo "$OUTPUT_FILE.gz"
