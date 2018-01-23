#!/usr/bin/env sh
# Move files to app root and site-install/update.

# Check if this is a new deployment.
if [[ ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Create Database.
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h ${MYSQL_HOSTNAME} -P ${MYSQL_PORT} -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db CHARACTER SET utf8 COLLATE utf8_general_ci; CREATE USER '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"

  # Perform site-install.
  cd ${DRUPAL_ROOT}
  /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`" drush site-install "${DRUPAL_SITE_ID}" -y --verbose --account-name="${DRUPAL_ADMIN_ACCOUNT_NAME}" --account-pass="${DRUPAL_ADMIN_ACCOUNT_PASS}" --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_DB_PASSWORD@${MYSQL_HOSTNAME}:${MYSQL_PORT}/${DRUPAL_SITE_ID}_db"
  rm -f ${DRUPAL_ROOT}/install.php

  # Ensure local settings are being applied.
  grep -q -F 'sites/all/settings/base.settings.php' "${DRUPAL_ROOT}/sites/default/settings.php" || echo "require DRUPAL_ROOT . '/sites/all/settings/base.settings.php';" >> "${DRUPAL_ROOT}/sites/default/settings.php"

# See if the instance appears to have previously been deployed
elif [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Previously installed, make sure install is removed.
  rm -f ${DRUPAL_ROOT}/install.php
else
  # Inconsistency detected, do nothing to avoid data loss.
  echo "Something seems odd with the Database and Filesystem, cowardly refusing to do anything"
fi
