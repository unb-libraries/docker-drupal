#!/usr/bin/env sh

# Copy build files into a temporary build location.
mkdir ${DRUPAL_BUILD_TMPROOT}
cp ${TMP_DRUPAL_BUILD_DIR}/composer.json ${DRUPAL_BUILD_TMPROOT}
cp -r ${TMP_DRUPAL_BUILD_DIR}/scripts ${DRUPAL_BUILD_TMPROOT}
cd ${DRUPAL_BUILD_TMPROOT}

# Build instance.
composer install --${COMPOSER_DEPLOY_DEV}

# Configure scaffolding files.
ln -s ${DRUPAL_BUILD_TMPROOT}/vendor/bin/drush /usr/bin/drush
ln -s ${DRUPAL_BUILD_TMPROOT}/vendor/bin/drupal /usr/bin/drupal

# Move profile from repo to build root.
mv ${TMP_DRUPAL_BUILD_DIR}/${DRUPAL_SITE_ID} ${DRUPAL_BUILD_TMPROOT}/profiles/

# Copy config from standard install profile for current version of Drupal.
cp -r ${DRUPAL_BUILD_TMPROOT}/core/profiles/standard/config ${DRUPAL_BUILD_TMPROOT}/profiles/${DRUPAL_SITE_ID}/

# Move settings files into build location.
mkdir -p ${DRUPAL_BUILD_TMPROOT}/sites/all
mv ${TMP_DRUPAL_BUILD_DIR}/settings ${DRUPAL_BUILD_TMPROOT}/sites/all/
