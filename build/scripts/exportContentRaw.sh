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
DUMP_FILE="$1/db.sql"
OUTPUT_FILE="$1/db.sql.gz"
/scripts/sqlDump.sh "$DUMP_FILE"

# Compress and checksum in a single pass: gzip once, tee the compressed stream
# to disk while feeding it to sha256sum. pipefail (busybox ash) + set -e abort
# the snapshot if gzip fails, so a truncated archive is never stored.
set -o pipefail
gzip -c "$DUMP_FILE" | tee "$OUTPUT_FILE" | sha256sum | cut -d' ' -f1 > "$OUTPUT_FILE.sha256"
rm -f "$DUMP_FILE"
echo "$OUTPUT_FILE"
