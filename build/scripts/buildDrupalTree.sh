#!/usr/bin/env sh
set -e

# Set-up Composer
cp /build/composer.json "$DRUPAL_ROOT"
cd "$DRUPAL_ROOT"

# Get latest composer/ScriptHandler.php.
mkdir -p scripts/composer
curl -O https://raw.githubusercontent.com/drupal-composer/drupal-project/9.x/scripts/composer/ScriptHandler.php
mv ScriptHandler.php scripts/composer/

# Build application.
BUILD_COMMAND="php -d memory_limit=-1 "/usr/local/bin/$COMPOSER_INSTALL" --no-dev"
echo "Updating Drupal [$BUILD_COMMAND]"
${BUILD_COMMAND}

# Backup the settings directory for use with a fresh install.
cp -r /app/html/sites/default /tmp/

# Move settings files into webroot.
${RSYNC_MOVE} /build/settings "$DRUPAL_ROOT/sites/all/"

# Add drush and drupal console PATH locations.
ln -s "$DRUPAL_ROOT/vendor/bin/drush" /usr/bin/drush
ln -s "$DRUPAL_ROOT/vendor/bin/drupal" /usr/bin/drupal

# Set default permissions.
find "$DRUPAL_ROOT" -not \( -path "$DRUPAL_ROOT/sites/default/files" -prune \) -not -user root -not -group root -print0 | xargs -r0 chown root:root --

# Ensure the configuration sync directory exists.
mkdir -p "$DRUPAL_ROOT/config/sync"
chown "$NGINX_RUN_USER":"$NGINX_RUN_USER" "$DRUPAL_ROOT/config/sync"

# Move services to /app/services.
if [ -d "/build/services" ]; then
  ${RSYNC_MOVE} /build/services /app/
fi
