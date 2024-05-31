#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No target location specified."
  exit 1
fi

mkdir -p "$1"

OUTPUT_FILE="$1/files.tar.gz"
/scripts/clearDrupalCache.sh > /dev/null 2>&1
cd "$DRUPAL_ROOT/sites/default/files"
tar -cvpzf "$1/files.tar.gz" --exclude=*.css --exclude=*.css.gz --exclude=*.js --exclude=*.js.gz --exclude=./php --exclude=./styles . > /dev/null 2>&1
echo "$OUTPUT_FILE"
