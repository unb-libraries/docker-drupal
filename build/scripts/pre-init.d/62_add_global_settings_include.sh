#!/usr/bin/env sh
# Wire the baked global settings include into settings.php.
# Runs after 61_add_base_settings_include and before 63_write_protect_settings.
grep -q -F '/app/php/global.settings.php' "$DRUPAL_ROOT/sites/default/settings.php" 2>/dev/null || \
  echo "require '/app/php/global.settings.php';" >> "$DRUPAL_ROOT/sites/default/settings.php"
