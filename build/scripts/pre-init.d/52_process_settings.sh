#!/usr/bin/env sh
# Add environment based settings files to settings

# Copy default services if no services.yml has been provided
ENV_SETTINGS_FILE="$DRUPAL_ROOT/sites/all/settings/settings.$DEPLOY_ENV.inc"

if [ -f "$ENV_SETTINGS_FILE" ]; then
  tail -n +2 "$ENV_SETTINGS_FILE" >> "$DRUPAL_ROOT/sites/all/settings/base.settings.php"
fi
