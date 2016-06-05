#!/usr/bin/env sh
# Move files to app root and site-install/update.

# Check if this is a new deployment.
if [[ ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Tidy up target webroot and transfer the pre-built drupal tree.
  rm -rf ${DRUPAL_ROOT}/*
  rsync -a --progress ${DRUSH_MAKE_TMPROOT}/ ${DRUPAL_ROOT}/

  # Create Database.
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h ${MYSQL_HOSTNAME} -P ${MYSQL_PORT} -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"

  # Perform site-install.
  cd ${DRUPAL_ROOT}
  /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`" drush site-install ${DRUPAL_SITE_ID} -y --verbose --account-name=${DRUPAL_ADMIN_ACCOUNT_NAME} --account-pass=${DRUPAL_ADMIN_ACCOUNT_PASS} --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_DB_PASSWORD@${MYSQL_HOSTNAME}:${MYSQL_PORT}/${DRUPAL_SITE_ID}_db"
  rm -f ${DRUPAL_ROOT}/install.php

  # Ensure local settings are being applied.
  grep -q -F 'sites/all/settings/base.settings.php' "${DRUPAL_ROOT}/sites/default/settings.php" || echo "require DRUPAL_ROOT . '/sites/all/settings/base.settings.php';" >> "${DRUPAL_ROOT}/sites/default/settings.php"

# See if the instance appears to have previously been deployed
elif [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Site Needs Upgrade
  echo "Database Exists and Files Found. DRUPAL_REBUILD_ON_REDEPLOY=$DRUPAL_REBUILD_ON_REDEPLOY"

  # Ensure the database details are still valid.
  sed -i "s|'host' => '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}',|'host' => '$MYSQL_HOSTNAME',|g" ${DRUPAL_ROOT}/sites/default/settings.php
  sed -i "s|'port' => '[0-9]\{2,4\}',|'port' => '$MYSQL_PORT',|g" ${DRUPAL_ROOT}/sites/default/settings.php

  if [[ "$DRUPAL_REBUILD_ON_REDEPLOY" == "TRUE" ]];
  then
    echo "Updating Existing Site.."

    # Transfer the pre-built drupal tree.
    rsync -a --progress --no-perms --no-owner --no-group --delete --exclude=sites/default/files/ --exclude=sites/default/settings.php --exclude=install.php ${DRUSH_MAKE_TMPROOT}/ ${DRUPAL_ROOT}/

    # Ensure local settings are being applied.
    grep -q -F 'sites/all/settings/base.settings.php' "${DRUPAL_ROOT}/sites/default/settings.php" || echo "require DRUPAL_ROOT . '/sites/all/settings/base.settings.php';" >> "${DRUPAL_ROOT}/sites/default/settings.php"

    # Apply database updates, if they exist.
    drush --yes --root=${DRUPAL_ROOT} --uri=default updb

  fi
  rm -f ${DRUPAL_ROOT}/install.php
else
  # Inconsistency detected, do nothing to avoid data loss.
  echo "Something seems odd with the Database and Filesystem, cowardly refusing to do anything"
fi
