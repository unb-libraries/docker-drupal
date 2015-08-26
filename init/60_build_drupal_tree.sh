#!/usr/bin/env bash

MYSQL_PORT_3306_TCP_ADDR="${MYSQL_PORT_3306_TCP_ADDR:-$(echo $MYSQL_HOSTNAME)}"
MYSQL_PORT_3306_TCP_PORT="${MYSQL_PORT_3306_TCP_PORT:-$(echo $MYSQL_PORT)}"

# Determine the SITE_ID
if env | grep -q ^DRUPAL_SITE_ID=
then
  echo "DRUPAL_SITE_ID set to $DRUPAL_SITE_ID"
else
  DRUPAL_SITE_ID='unblibdef'
fi

# Determine the BUILD_SLUG
if [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID.makefile" ] || [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID/$DRUPAL_SITE_ID.install" ] || [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID/$DRUPAL_SITE_ID.info" ] || [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID/$DRUPAL_SITE_ID.profile" ]
then
  DRUPAL_BUILD_SLUG='unblibdef'
else
  DRUPAL_BUILD_SLUG=$DRUPAL_SITE_ID
fi

# Build / Update Site
if [[ ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Initial deploy, site needs install
  rm -rf ${DRUPAL_ROOT}/*
  cd ${DRUPAL_ROOT}
  drush make --yes "/tmp/drupal_build/$DRUPAL_BUILD_SLUG.makefile"

  # Create Database
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h ${MYSQL_PORT_3306_TCP_ADDR} -P ${MYSQL_PORT_3306_TCP_PORT} -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"

  # Install
  cd ${DRUPAL_ROOT}
  cp -r /tmp/drupal_build/$DRUPAL_BUILD_SLUG/ profiles/
  drush site-install $DRUPAL_BUILD_SLUG -y --account-name=admin --account-pass=admin --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_DB_PASSWORD@${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}/${DRUPAL_SITE_ID}_db"

  # Apply settings overrides
  OVERRIDE_SOURCE_FILE='/tmp/drupal_build/settings_override.php'
  OVERRIDE_TARGET_FILE="${DRUPAL_ROOT}/sites/default/settings.php"
  if [ -e $OVERRIDE_SOURCE_FILE ]; then
    while read -u 10 CONF_LINE; do
      TRIMMED_LINE=`echo "$CONF_LINE" | xargs`
      grep -q "^${TRIMMED_LINE}$" $OVERRIDE_TARGET_FILE || echo "$TRIMMED_LINE" >> $OVERRIDE_TARGET_FILE
    done 10<$OVERRIDE_SOURCE_FILE
  fi
elif [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Site Needs Upgrade
  echo "Database Exists and Files Found, Updating Existing Site"

  # Ensure Databse String Valid
  sed -i "s|'host' => '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}',|'host' => '$MYSQL_PORT_3306_TCP_ADDR',|g" ${DRUPAL_ROOT}/sites/default/settings.php
  sed -i "s|'port' => '[0-9]\{2,4\}',|'port' => '$MYSQL_PORT_3306_TCP_PORT',|g" ${DRUPAL_ROOT}/sites/default/settings.php

  rm -rf /tmp/html
  mkdir /tmp/html
  cd /tmp/html

  # Making temporary build location
  drush make --yes "/tmp/drupal_build/$DRUPAL_BUILD_SLUG.makefile"

  # Deploy to live dir
  cp -r /tmp/drupal_build/$DRUPAL_BUILD_SLUG/ /tmp/html/profiles/
  cd ..

  chown 500:500 -R /tmp/html
  rsync --verbose --recursive --exclude=sites/default/files/ --exclude=sites/default/settings.php --exclude=profiles/$DRUPAL_BUILD_SLUG --perms --delete --omit-dir-times --chmod=o+r /tmp/html/ ${DRUPAL_ROOT}

  # Apply settings overrides
  OVERRIDE_SOURCE_FILE='/tmp/drupal_build/settings_override.php'
  OVERRIDE_TARGET_FILE="${DRUPAL_ROOT}/sites/default/settings.php"
  if [ -e $OVERRIDE_SOURCE_FILE ]; then
    while read -u 10 CONF_LINE; do
      TRIMMED_LINE=`echo "$CONF_LINE" | xargs`
      grep -q "^${TRIMMED_LINE}$" $OVERRIDE_TARGET_FILE || echo "$TRIMMED_LINE" >> $OVERRIDE_TARGET_FILE
    done 10<$OVERRIDE_SOURCE_FILE
  fi

  cd ${DRUPAL_ROOT}
  drush --yes updb
else
  # Yikes
  echo "Something seems odd with the Database and Filesystem, cowardly refusing to do anything"
fi
