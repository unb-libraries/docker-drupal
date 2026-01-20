#!/usr/bin/env sh
# Output list of currently enabled projects (one per line)
# Usage: getEnabledProjects.sh <module|theme>

TYPE="$1"
if [ "$TYPE" != "module" ] && [ "$TYPE" != "theme" ]; then
  echo "Usage: $0 <module|theme>" >&2
  exit 1
fi

${DRUSH} pm:list --status=enabled --type="$TYPE" --format=list
