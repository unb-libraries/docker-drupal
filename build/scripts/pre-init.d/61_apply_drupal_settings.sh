#!/usr/bin/env sh
# Ensure local settings are applied.
grep -q -F 'sites/all/settings/base.settings.php' "${DRUPAL_ROOT}/sites/default/settings.php" || echo "require DRUPAL_ROOT . '/sites/all/settings/base.settings.php';" >> "${DRUPAL_ROOT}/sites/default/settings.php"
chown root:root "${DRUPAL_ROOT}/sites/default/settings.php"
chmod -w "${DRUPAL_ROOT}/sites/default/settings.php"
