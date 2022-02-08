#!/usr/bin/env sh
#
# Forcibly truncate all cache tables.
drush sql-query "SELECT table_name FROM information_schema.tables WHERE table_name LIKE 'cache\_%';" | ( while read -r LINE ; do
  if [ -n "$LINE" ]; then
    COMMAND="$COMMAND TRUNCATE TABLE $LINE;"
  fi
done
echo "Executing $COMMAND..."
$DRUSH sqlq "$COMMAND" && echo "Tables Truncated!" )
