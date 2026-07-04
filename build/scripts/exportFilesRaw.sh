#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

mkdir -p "$1"

# Raw files export: archive the public filesystem without clearing the cache.
# Archive and checksum in a single pass: tar/gzip streams to stdout, tee writes
# it to disk while feeding it to sha256sum. pipefail (busybox ash) + set -e
# abort the snapshot if tar fails, so a truncated archive is never stored.
OUTPUT_FILE="$1/files.tar.gz"
cd "$DRUPAL_ROOT/sites/default/files"
set -o pipefail
tar -cpz --exclude=*.css --exclude=*.css.gz --exclude=*.js --exclude=*.js.gz --exclude=./php --exclude=./styles . 2>/dev/null \
  | tee "$OUTPUT_FILE" \
  | sha256sum | cut -d' ' -f1 > "$OUTPUT_FILE.sha256"
echo "$OUTPUT_FILE"
