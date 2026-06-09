#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No database file specified!"
  exit 1
elif [ ! -f "$1" ] ; then
  echo "$1 does not exist!"
  exit 1
fi

# Raw database import: decompress and feed the dump into the database. No cache
# rebuild or other wrapper steps - intended for callers that run their own
# startup/upgrade sequence afterward (e.g. drupal:test-upgrade).
EXTRACTED_PATH=$(echo $1 | rev | cut -f 2- -d '.' | rev)
EXTRACTED_FILE=$(basename "$EXTRACTED_PATH")
gunzip -c "$1" > "/tmp/$EXTRACTED_FILE"
echo "Importing $EXTRACTED_FILE"
# Use sql:connect (returns a mysql connect string) instead of piping the dump to
# sql:cli — drush warns that large amounts of data via stdin to sql:cli is slow.
SQL_CONN=$($DRUSH sql:connect)
$SQL_CONN < "/tmp/$EXTRACTED_FILE"
rm -f "/tmp/$EXTRACTED_FILE"
