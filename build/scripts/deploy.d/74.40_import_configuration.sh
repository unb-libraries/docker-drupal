#!/usr/bin/env sh
# Configuration
if [ -d "$DRUPAL_CONFIGURATION_DIR" ] && [ "$(ls $DRUPAL_CONFIGURATION_DIR)" ]; then
  # Import configuration 3 times due to Drupal dependency ordering issues.
  # See: https://github.com/drush-ops/drush/issues/2449
  # Also: https://www.drupal.org/project/drupal/issues/3241439
  # Only the final import is fatal (under set -e from run.sh).
  /scripts/configImport.sh || true
  /scripts/configImport.sh || true
  /scripts/configImport.sh
fi
