#!/usr/bin/env sh
# Check if this is a new deployment. If so, install.
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  # Deploy the sites/default tree likely removed by the volume.
  rsync -a /tmp/default /app/html/sites/
  chown -R "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" /app/html/sites/default
  chmod +w /app/html/sites/default/settings.php

  # Create the database.
  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOSTNAME" -P "$MYSQL_PORT" -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db CHARACTER SET utf8 COLLATE utf8_general_ci; CREATE USER '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"

  # Perform a drush site-install.
  cd "$DRUPAL_ROOT"
  /usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`" "$DRUSH" site-install minimal --verbose --account-name="$DRUPAL_ADMIN_ACCOUNT_NAME" --account-pass="$DRUPAL_ADMIN_ACCOUNT_PASS" --db-url="mysqli://${DRUPAL_SITE_ID}_user:$DRUPAL_DB_PASSWORD@$MYSQL_HOSTNAME:$MYSQL_PORT/${DRUPAL_SITE_ID}_db"
fi
