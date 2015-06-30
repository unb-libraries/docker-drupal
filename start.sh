#!/bin/bash

# Determine the SITE_ID
if env | grep -q ^DRUPAL_SITE_ID=
then
  echo "DRUPAL_SITE_ID set to $DRUPAL_SITE_ID"
else
  DRUPAL_SITE_ID='unblibdefault'
fi

# Determine the BUILD_SLUG
if [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID.makefile" ] || [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID/$DRUPAL_SITE_ID.install" ] || [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID/$DRUPAL_SITE_ID.info" ] || [ ! -e "/tmp/drupal_build/$DRUPAL_SITE_ID/$DRUPAL_SITE_ID.profile" ]
then
  DRUPAL_BUILD_SLUG='unblibdefault'
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
if [ ! -e /var/www/drupal/htdocs/sites/default/settings.php ]; then
  FILES_LIVE="NO"
else
  FILES_LIVE="YES"
fi

# Build / Update Site
if [ "$DB_LIVE" == "NO" ] && [ "$FILES_LIVE" == "NO" ]
then
  # Initial deploy, site needs install
  mkdir -p /var/www/drupal/htdocs
  cd /var/www/drupal/htdocs
  drush make --yes "/tmp/drupal_build/$DRUPAL_BUILD_SLUG.makefile"

  # Create Database
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOSTNAME -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"

  # Install
  cd /var/www/drupal/htdocs
  cp -r /tmp/drupal_build/$DRUPAL_BUILD_SLUG/ profiles/
  drush site-install $DRUPAL_BUILD_SLUG -y --account-name=admin --account-pass=admin --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_PASSWORD@$MYSQL_HOSTNAME:3306/${DRUPAL_SITE_ID}_db"

  # Drupal Permissions
  chown root:root -R /var/www/drupal/htdocs
  chown www-data:www-data -R /var/www/drupal/htdocs/sites/default/files
  chown root:root -R /var/www/drupal/htdocs/sites/default/files/.htaccess
elif [ "$DB_LIVE" == "YES" ] && [ "$FILES_LIVE" == "YES" ]
then
  # Site Needs Upgrade
  echo "Database Exists and Files Found, Updating Existing Site"
  rm -rf /tmp/htdocs
  mkdir /tmp/htdocs
  cd /tmp/htdocs

  # Making temporary build location
  drush make --yes "/tmp/drupal_build/$DRUPAL_BUILD_SLUG.makefile"

  # Deploy to live dir
  cp -r /tmp/drupal_build/$DRUPAL_BUILD_SLUG/ /tmp/htdocs/profiles/
  cd ..
  rsync --verbose --recursive --delete --omit-dir-times --chmod=o+r --perms --exclude=htdocs/sites/default/files/ --exclude=htdocs/sites/default/settings.php --exclude=htdocs/profiles/$DRUPAL_BUILD_SLUG htdocs /var/www/drupal

  # Run DB Updates
  cd /var/www/drupal/htdocs
  drush --yes cc all
  drush --yes updb

  # Drupal Permissions
  chown root:root -R /var/www/drupal/htdocs
  chown www-data:www-data -R /var/www/drupal/htdocs/sites/default/files
  chown root:root -R /var/www/drupal/htdocs/sites/default/files/.htaccess
else
  # Yikes
  echo "DB: $DB_LIVE FILES: $FILES_LIVE"
  echo "Something seems odd, cowardly refusing to do anything"
fi

php5-fpm -c /etc/php5/fpm &
service nginx start
