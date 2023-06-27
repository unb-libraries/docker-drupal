#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

mkdir -p "$1"

OUTPUT_FILE="$1/files.tar.gz"
/scripts/clearDrupalCache.sh
tar -cvpzf "$1/files.tar.gz" --exclude=*.css --exclude=*.css.gz --exclude=*.js --exclude=*.js.gz --exclude=app/html/sites/default/files/php --exclude=app/html/sites/default/files/styles /app/html/sites/default/files
echo "$OUTPUT_FILE"
