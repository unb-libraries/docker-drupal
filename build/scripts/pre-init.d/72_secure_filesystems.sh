#!/usr/bin/env sh
for FILESYSTEM in 'private://' 'public://'; do
  FILESYSTEM_PATH=$($DRUSH eval "echo \Drupal::service('file_system')->realpath('$FILESYSTEM');")
  if [ "$FILESYSTEM_PATH" ]; then
    echo "Securing $FILESYSTEM [$FILESYSTEM_PATH]..."
    $DRUSH eval 'use Drupal\Component\FileSecurity\FileSecurity; print FileSecurity::htaccessLines(FALSE)' > "$FILESYSTEM_PATH/.htaccess"
    chown root:root "$FILESYSTEM_PATH/.htaccess"
  fi
done
