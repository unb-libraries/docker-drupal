#!/usr/bin/env sh
set -e

# Dev/NoDev
DRUPAL_COMPOSER_DEV="${1:-no-dev}"

# Profile ID
DRUPAL_BASE_PROFILE="${2:-minimal}"

# Remove upstream assets
rm -rf ${DRUPAL_ROOT}/profiles/defaultd
rm -rf ${DRUPAL_ROOT}/sites/all/settings

# Build instance.
cp /build/composer.json ${DRUPAL_ROOT}
cd ${DRUPAL_ROOT}
BUILD_COMMAND="composer update --no-suggest --prefer-dist --no-interaction --${DRUPAL_COMPOSER_DEV}"
echo "Updating Drupal [${BUILD_COMMAND}]"
${BUILD_COMMAND}

# Create the profile folder.
mkdir -p "${DRUPAL_ROOT}/profiles/${DRUPAL_SITE_ID}"

# Copy config from core install profile for current version of Drupal.
rsync -a --inplace --no-compress ${RSYNC_FLAGS} "${DRUPAL_ROOT}/core/profiles/${DRUPAL_BASE_PROFILE}/config" "${DRUPAL_ROOT}/profiles/${DRUPAL_SITE_ID}/"

# Copy additional configs provided by this extension.
ADDITIONAL_CONFIG_DIR="/scripts/data/profiles/${DRUPAL_BASE_PROFILE}/config"
if [[ -d "$ADDITIONAL_CONFIG_DIR" ]]; then
  rsync -a --inplace --no-compress ${RSYNC_FLAGS} ${ADDITIONAL_CONFIG_DIR} ${DRUPAL_ROOT}/profiles/${DRUPAL_SITE_ID}/
fi

# Move local profile from repo to webroot, overwriting.
rsync -a --inplace --no-compress ${RSYNC_FLAGS} --remove-source-files /build/${DRUPAL_SITE_ID} ${DRUPAL_ROOT}/profiles/

# Move settings files into webroot.
rsync -a --inplace --no-compress ${RSYNC_FLAGS} --remove-source-files /build/settings ${DRUPAL_ROOT}/sites/all/

# Add drush and drupal console PATH locations.
ln -s ${DRUPAL_ROOT}/vendor/bin/drush /usr/bin/drush
ln -s ${DRUPAL_ROOT}/vendor/bin/drupal /usr/bin/drupal

# Set default permissions.
find ${DRUPAL_ROOT} -not \( -path "${DRUPAL_ROOT}/sites/default/files" -prune \) -not -user root -not -group root -print0 | xargs -r0 chown root:root --

# Ensure the configuration sync directory exists.
mkdir -p ${DRUPAL_ROOT}/config/sync
chown ${NGINX_RUN_USER}:${NGINX_RUN_USER} ${DRUPAL_ROOT}/config/sync
