#!/usr/bin/env sh

# Here, we default to using the address from a linked container named 'mysql', falling back to using the
# details provided through MYSQL_HOSTNAME and MYSQL_PORT environment variables.
MYSQL_PORT_3306_TCP_ADDR="${MYSQL_PORT_3306_TCP_ADDR:-$(echo $MYSQL_HOSTNAME)}"
MYSQL_PORT_3306_TCP_PORT="${MYSQL_PORT_3306_TCP_PORT:-$(echo $MYSQL_PORT)}"

# Check if this is a new deployment.
if [[ ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Tidy up target webroot and transfer the pre-built drupal tree.
  rm -rf ${DRUPAL_ROOT}/*
  rsync -a --progress ${DRUSH_MAKE_TMPROOT}/ ${DRUPAL_ROOT}/

  # Create Database.
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h ${MYSQL_PORT_3306_TCP_ADDR} -P ${MYSQL_PORT_3306_TCP_PORT} -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"

  # Perform site-install.
  cd ${DRUPAL_ROOT}
  /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`" drush site-install ${DRUPAL_SITE_ID} -y --verbose --account-name=${DRUPAL_ADMIN_ACCOUNT_NAME} --account-pass=${DRUPAL_ADMIN_ACCOUNT_PASS} --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_DB_PASSWORD@${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}/${DRUPAL_SITE_ID}_db"
  rm -f ${DRUPAL_ROOT}/install.php

# See if the instance appears to have previously been deployed
elif [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Site Needs Upgrade
  echo "Database Exists and Files Found. DRUPAL_REBUILD_ON_REDEPLOY=$DRUPAL_REBUILD_ON_REDEPLOY"

  # Ensure the database details are still valid.
  sed -i "s|'host' => '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}',|'host' => '$MYSQL_PORT_3306_TCP_ADDR',|g" ${DRUPAL_ROOT}/sites/default/settings.php
  sed -i "s|'port' => '[0-9]\{2,4\}',|'port' => '$MYSQL_PORT_3306_TCP_PORT',|g" ${DRUPAL_ROOT}/sites/default/settings.php

  if [[ "$DRUPAL_REBUILD_ON_REDEPLOY" == "TRUE" ]];
  then
    echo "Updating Existing Site.."

    # Transfer the pre-built drupal tree.
    rsync -a --progress --no-perms --no-owner --no-group --delete --exclude=sites/default/files/ --exclude=sites/default/settings.php --exclude=install.php ${DRUSH_MAKE_TMPROOT}/ ${DRUPAL_ROOT}/

    # Apply database updates, if they exist.
    drush --yes --root=${DRUPAL_ROOT} --uri=default updb

  fi
  rm -f ${DRUPAL_ROOT}/install.php
else
  # Inconsistency detected, do nothing to avoid data loss.
  echo "Something seems odd with the Database and Filesystem, cowardly refusing to do anything"
fi
