#!/usr/bin/env sh
YQ_VERSION="2.4.1"

# Install prestissimo.
composer global require --prefer-dist hirak/prestissimo

# Get latest composer/ScriptHandler.php.
rm -rf "${DRUPAL_ROOT}"
mkdir -p "${DRUPAL_ROOT}/scripts/composer"
curl -o "${DRUPAL_ROOT}/scripts/composer/ScriptHandler.php" -O https://raw.githubusercontent.com/drupal-composer/drupal-project/8.x/scripts/composer/ScriptHandler.php

# Build instance.
cd "${DRUPAL_ROOT}"
cp /build/composer.json .
BUILD_COMMAND="composer install --no-ansi --prefer-dist --no-dev"
echo "Building - $BUILD_COMMAND"
$BUILD_COMMAND

# Move custom install profile from build to webtree.
mv /build/${DRUPAL_SITE_ID} ${DRUPAL_ROOT}/profiles/

# Copy config from standard install profile to custom profile config.
cp -r ${DRUPAL_ROOT}/core/profiles/standard/config ${DRUPAL_ROOT}/profiles/${DRUPAL_SITE_ID}/

# Move settings files into build location.
mkdir -p ${DRUPAL_ROOT}/sites/all
mv /build/settings ${DRUPAL_ROOT}/sites/all/

# Set default permissions.
find ${DRUPAL_ROOT} \! -user root \! -group root -not \( -path "${DRUPAL_ROOT}/sites/default/files" -prune \) -print0 | xargs -r0 chown root:root --

# Install yq for yaml combination scripts.
echo "Downloading yq binary..."
curl -sL https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq; chmod +x /usr/bin/yq

# Ensure the configuration sync directory exists.
mkdir -p ${DRUPAL_ROOT}/config/sync
chown ${NGINX_RUN_USER}:${NGINX_RUN_USER} ${DRUPAL_ROOT}/config/sync

# Move services to /app/services.
mkdir -p /app/services
cp -r /build/services/* /app/services/
