#!/usr/bin/env bash

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

# Triage request
RESULT=`mysqlshow -h $MYSQL_HOSTNAME --user=${DRUPAL_SITE_ID}_user --password=$DRUPAL_PASSWORD| grep -v Wildcard | grep -o ${DRUPAL_SITE_ID}_db`
if [ "$RESULT" == "${DRUPAL_SITE_ID}_db" ]; then
  DB_LIVE="YES"
else
  DB_LIVE="NO"
fi
if [ ! -e /usr/share/nginx/html/sites/default/settings.php ]; then
  FILES_LIVE="NO"
else
  FILES_LIVE="YES"
fi

# Build / Update Site
if [ "$DB_LIVE" == "NO" ] && [ "$FILES_LIVE" == "NO" ]
then
  # Initial deploy, site needs install
  rm -rf /usr/share/nginx/html/*
  cd /usr/share/nginx/html
  drush make --yes "/tmp/drupal_build/$DRUPAL_BUILD_SLUG.makefile"

  # Create Database
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOSTNAME -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"

  # Install
  cd /usr/share/nginx/html
  cp -r /tmp/drupal_build/$DRUPAL_BUILD_SLUG/ profiles/
  drush site-install $DRUPAL_BUILD_SLUG -y --account-name=admin --account-pass=admin --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_PASSWORD@$MYSQL_HOSTNAME:3306/${DRUPAL_SITE_ID}_db"

  # Apply settings overrides
  OVERRIDE_SOURCE_FILE='/tmp/drupal_build/settings_override.php'
  OVERRIDE_TARGET_FILE='/usr/share/nginx/html/sites/default/settings.php'
  if [ -e $OVERRIDE_SOURCE_FILE ]; then
    while read -u 10 CONF_LINE; do
      TRIMMED_LINE=`echo "$CONF_LINE" | xargs`
      grep -q "^${TRIMMED_LINE}$" $OVERRIDE_TARGET_FILE || echo "$TRIMMED_LINE" >> $OVERRIDE_TARGET_FILE
    done 10<$OVERRIDE_SOURCE_FILE
  fi
elif [ "$DB_LIVE" == "YES" ] && [ "$FILES_LIVE" == "YES" ]
then
  # Site Needs Upgrade
  echo "Database Exists and Files Found, Updating Existing Site"
  rm -rf /tmp/html
  mkdir /tmp/html
  cd /tmp/html

  # Making temporary build location
  drush make --yes "/tmp/drupal_build/$DRUPAL_BUILD_SLUG.makefile"

  # Deploy to live dir
  cp -r /tmp/drupal_build/$DRUPAL_BUILD_SLUG/ /tmp/html/profiles/
  cd ..
  rsync --verbose --recursive --delete --omit-dir-times --chmod=o+r --perms --exclude=html/sites/default/files/ --exclude=html/sites/default/settings.php --exclude=html/profiles/$DRUPAL_BUILD_SLUG html /usr/share/nginx

  # Apply settings overrides
  OVERRIDE_SOURCE_FILE='/tmp/drupal_build/settings_override.php'
  OVERRIDE_TARGET_FILE='/usr/share/nginx/html/sites/default/settings.php'
  if [ -e $OVERRIDE_SOURCE_FILE ]; then
    while read -u 10 CONF_LINE; do
      TRIMMED_LINE=`echo "$CONF_LINE" | xargs`
      grep -q "^${TRIMMED_LINE}$" $OVERRIDE_TARGET_FILE || echo "$TRIMMED_LINE" >> $OVERRIDE_TARGET_FILE
    done 10<$OVERRIDE_SOURCE_FILE
  fi

  # Run DB Updates
  cd /usr/share/nginx/html
  drush --yes updb
else
  # Yikes
  echo "DB: $DB_LIVE FILES: $FILES_LIVE"
  echo "Something seems odd, cowardly refusing to do anything"
fi
