#!/usr/bin/env sh
set -e

# Wrapper step: clear the cache so cache tables are not included in the dump.
/scripts/clearDrupalCache.sh > /dev/null 2>&1

# Raw content export.
/scripts/exportContentRaw.sh "$1"
