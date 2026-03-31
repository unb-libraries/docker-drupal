if [ -f /tmp/DRUPAL_DB_LIVE ] && [ -f /tmp/DRUPAL_FILES_LIVE ];
then
  echo "Executing outstanding hook_update() hooks..."
  $DRUSH updb
fi
