#!/usr/bin/env sh
# Triage the filesystem status.

# Remove possible old file marker to eliminate false positives
rm -rf /tmp/DRUPAL_FILES_LIVE

# Determine if the site was previously built by checking for settings.php and that a 'files' directory exists under $DRUPAL_PUBLIC_FILES_ROOT.
DRUPAL_PUBLIC_FILES_ROOT="$DRUPAL_ROOT/sites/default"
if [ -f "$DRUPAL_PUBLIC_FILES_ROOT/settings.php" ] && [ -f "$DRUPAL_PUBLIC_FILES_ROOT/files/.htaccess" ]; then
  touch /tmp/DRUPAL_FILES_LIVE
  echo "Triage : Found Drupal Filesystem: settings.php and 'files/.htaccess' directory."
else
  echo "Triage : settings.php or 'files' directory not found."
fi
