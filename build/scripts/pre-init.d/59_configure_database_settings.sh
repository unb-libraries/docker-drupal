#!/usr/bin/env sh
# Configure database settings in settings.php for existing installations.
# This script substitutes database connection values from environment variables.

# Only run for existing installations (both markers must exist)
if [ -f /tmp/DRUPAL_DB_LIVE ] && [ -f /tmp/DRUPAL_FILES_LIVE ]; then
  SETTINGS_FILE="$DRUPAL_ROOT/sites/default/settings.php"

  if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Warning: settings.php not found at $SETTINGS_FILE"
    exit 1
  fi

  echo "Configuring database settings in settings.php..."

  # Construct namespace from driver
  DRUPAL_DB_NAMESPACE="Drupal\\\\Core\\\\Database\\\\Driver\\\\$DRUPAL_DB_DRIVER"

  # Substitute database fields in single sed invocation
  # Handles both single and double quoted values via character class
  sed -i \
    -e "s|['\"]database['\"] => ['\"][^'\"]*['\"]|'database' => '$DRUPAL_DB_NAME'|g" \
    -e "s|['\"]username['\"] => ['\"][^'\"]*['\"]|'username' => '$DRUPAL_DB_USER'|g" \
    -e "s|['\"]password['\"] => ['\"][^'\"]*['\"]|'password' => '$DRUPAL_DB_PASSWORD'|g" \
    -e "s|['\"]prefix['\"] => ['\"][^'\"]*['\"]|'prefix' => '$DRUPAL_DB_PREFIX'|g" \
    -e "s|['\"]host['\"] => ['\"][^'\"]*['\"]|'host' => '$DRUPAL_DB_HOSTNAME'|g" \
    -e "s|['\"]port['\"] => ['\"][^'\"]*['\"]|'port' => '$DRUPAL_DB_PORT'|g" \
    -e "s|['\"]driver['\"] => ['\"][^'\"]*['\"]|'driver' => '$DRUPAL_DB_DRIVER'|g" \
    -e "s|['\"]namespace['\"] => ['\"][^'\"]*['\"]|'namespace' => '$DRUPAL_DB_NAMESPACE'|g" \
    "$SETTINGS_FILE"

  echo "Database settings configured successfully."
fi
