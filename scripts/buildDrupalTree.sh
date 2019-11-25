#!/usr/bin/env sh

# Dev/NoDev
DRUPAL_COMPOSER_DEV="${1:-no-dev}"
YQ_VERSION="2.4.1"

# Copy build files into a temporary build location.
mkdir ${DRUPAL_BUILD_TMPROOT}
cp ${TMP_DRUPAL_BUILD_DIR}/composer.json ${DRUPAL_BUILD_TMPROOT}

# Change to the build directory
cd ${DRUPAL_BUILD_TMPROOT}

# Get latest composer/ScriptHandler.php.
mkdir -p scripts/composer
curl -O https://raw.githubusercontent.com/drupal-composer/drupal-project/8.x/scripts/composer/ScriptHandler.php
mv ScriptHandler.php scripts/composer/

# Install prestissimo.
composer global require hirak/prestissimo

# Build instance.
echo "Building - 'composer install --prefer-dist --${DRUPAL_COMPOSER_DEV}'"
composer install --no-ansi --prefer-dist --${DRUPAL_COMPOSER_DEV}

# Move profile from repo to build root.
mv ${TMP_DRUPAL_BUILD_DIR}/${DRUPAL_SITE_ID} ${DRUPAL_BUILD_TMPROOT}/profiles/

# Copy config from standard install profile for current version of Drupal.
cp -r ${DRUPAL_BUILD_TMPROOT}/core/profiles/standard/config ${DRUPAL_BUILD_TMPROOT}/profiles/${DRUPAL_SITE_ID}/

# Move settings files into build location.
mkdir -p ${DRUPAL_BUILD_TMPROOT}/sites/all
mv ${TMP_DRUPAL_BUILD_DIR}/settings ${DRUPAL_BUILD_TMPROOT}/sites/all/

# Install yq for yaml
echo "Downloading yq binary..."
curl -sL https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq; chmod +x /usr/bin/yq
