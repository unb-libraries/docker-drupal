#!/usr/bin/env sh
# Apply pending database updates BEFORE any step that rebuilds the router or
# container (e.g. 76_sync_extensions' module uninstalls, 77's `drush en`). A
# code update that changes a core/module schema (for example the router table)
# must have its update hooks applied first, otherwise those rebuilds run against
# the old schema and fail. Mirrors Drupal's canonical deploy order (updatedb
# before configuration import). This is a no-op when no updates are pending, so
# it has no effect on normal (non-upgrade) startups.
if [ -f /tmp/DRUPAL_DB_LIVE ] && [ -f /tmp/DRUPAL_FILES_LIVE ];
then
  echo "Executing outstanding hook_update() hooks..."
  $DRUSH updb
fi
