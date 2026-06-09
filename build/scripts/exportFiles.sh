#!/usr/bin/env sh
set -e

# Wrapper step: clear the cache before archiving.
/scripts/clearDrupalCache.sh > /dev/null 2>&1

# Raw files export.
/scripts/exportFilesRaw.sh "$1"
