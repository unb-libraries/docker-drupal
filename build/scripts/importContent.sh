#!/usr/bin/env sh
set -e

if [ $# -ne 1 ];then
  echo "No database file specified!"
  exit 1
elif [ ! -f "$1" ] ; then
  echo "$1 does not exist!"
  exit 1
fi

# Import the content.
EXTRACTED_FILE=$(echo $1 | rev | cut -f 2- -d '.' | rev)
gunzip -c "$1" >/tmp/$EXTRACTED_FILE
echo "Importing $EXTRACTED_FILE"
sh -c "$DRUSH sql-cli < /tmp/$EXTRACTED_FILE"
$DRUSH cr
