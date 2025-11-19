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

  # Substitute database fields - handle both single and double quotes
  # Each field has two sed commands: one for single quotes, one for double quotes

  # Database name
  sed -i "s|'database' => '[^']*'|'database' => '$DRUPAL_DB_NAME'|g" "$SETTINGS_FILE"
  sed -i "s|\"database\" => \"[^\"]*\"|\"database\" => \"$DRUPAL_DB_NAME\"|g" "$SETTINGS_FILE"

  # Username
  sed -i "s|'username' => '[^']*'|'username' => '$DRUPAL_DB_USER'|g" "$SETTINGS_FILE"
  sed -i "s|\"username\" => \"[^\"]*\"|\"username\" => \"$DRUPAL_DB_USER\"|g" "$SETTINGS_FILE"

  # Password
  sed -i "s|'password' => '[^']*'|'password' => '$DRUPAL_DB_PASSWORD'|g" "$SETTINGS_FILE"
  sed -i "s|\"password\" => \"[^\"]*\"|\"password\" => \"$DRUPAL_DB_PASSWORD\"|g" "$SETTINGS_FILE"

  # Prefix
  sed -i "s|'prefix' => '[^']*'|'prefix' => '$DRUPAL_DB_PREFIX'|g" "$SETTINGS_FILE"
  sed -i "s|\"prefix\" => \"[^\"]*\"|\"prefix\" => \"$DRUPAL_DB_PREFIX\"|g" "$SETTINGS_FILE"

  # Host
  sed -i "s|'host' => '[^']*'|'host' => '$DRUPAL_DB_HOSTNAME'|g" "$SETTINGS_FILE"
  sed -i "s|\"host\" => \"[^\"]*\"|\"host\" => \"$DRUPAL_DB_HOSTNAME\"|g" "$SETTINGS_FILE"

  # Port
  sed -i "s|'port' => '[^']*'|'port' => '$DRUPAL_DB_PORT'|g" "$SETTINGS_FILE"
  sed -i "s|\"port\" => \"[^\"]*\"|\"port\" => \"$DRUPAL_DB_PORT\"|g" "$SETTINGS_FILE"

  # Driver
  sed -i "s|'driver' => '[^']*'|'driver' => '$DRUPAL_DB_DRIVER'|g" "$SETTINGS_FILE"
  sed -i "s|\"driver\" => \"[^\"]*\"|\"driver\" => \"$DRUPAL_DB_DRIVER\"|g" "$SETTINGS_FILE"

  # Namespace (constructed from driver)
  sed -i "s|'namespace' => '[^']*'|'namespace' => '$DRUPAL_DB_NAMESPACE'|g" "$SETTINGS_FILE"
  sed -i "s|\"namespace\" => \"[^\"]*\"|\"namespace\" => \"$DRUPAL_DB_NAMESPACE\"|g" "$SETTINGS_FILE"

  echo "Database settings configured successfully."
fi
