#!/usr/bin/env sh
set -e

if [ $# -ne 1 ]; then
  echo "No import location specified!"
  exit 1
elif [ ! -f "$1/db.sql.gz" ] ; then
  echo "$1/db.sql.gz does not exist!"
  exit 1
fi

# Import Content.
/scripts/importContent.sh "$1/db.sql.gz"

# (Optionally) Import Files.
if [ -f "$1/files.tar.gz" ] ; then
  /scripts/importFiles.sh "$1/files.tar.gz"
fi

echo 'Success!'
