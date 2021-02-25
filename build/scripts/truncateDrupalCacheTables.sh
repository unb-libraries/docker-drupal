#!/usr/bin/env sh
#
# Forcibly truncate all cache tables.
drush sql-query "SELECT table_name FROM information_schema.tables WHERE table_name LIKE 'cache\_%';" | while read -r LINE ; do
  if [ -n "$LINE" ]; then
    COMMAND="TRUNCATE TABLE $LINE"
    echo "Truncating table [$LINE]..."
    drush sql-query "$COMMAND" 1> /dev/null
  fi
done
