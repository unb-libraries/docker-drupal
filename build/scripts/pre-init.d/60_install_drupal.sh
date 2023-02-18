#!/usr/bin/env sh
# Check if this is a new deployment. If so, install.
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  # Deploys the sites/default tree if removed by a local volume.
  rsync -a /tmp/default "$DRUPAL_ROOT/sites/"
  chown -R "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" "$DRUPAL_ROOT/sites/default"

  # Creates the database.
  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOSTNAME" -P "$MYSQL_PORT" -e "DROP DATABASE IF EXISTS ${DRUPAL_SITE_ID}_db; CREATE DATABASE ${DRUPAL_SITE_ID}_db CHARACTER SET utf8 COLLATE utf8_general_ci; CREATE USER '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; GRANT ALL PRIVILEGES ON ${DRUPAL_SITE_ID}_db.* TO '${DRUPAL_SITE_ID}_user'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"

  # Creates the database structure for an empty site via Drush.
  cd "$DRUPAL_ROOT" || exit
  chmod +w "$DRUPAL_ROOT/sites/default/settings.php"
  PHP_SET_SENDMAIL_NOWHERE="/usr/bin/env PHP_OPTIONS=\"-d sendmail_path=`which true`\""
  DRUPAL_DB_URI="mysql://${DRUPAL_SITE_ID}_user:$DRUPAL_DB_PASSWORD@$MYSQL_HOSTNAME:$MYSQL_PORT/${DRUPAL_SITE_ID}_db"
  $PHP_SET_SENDMAIL_NOWHERE $DRUSH site-install minimal --verbose --account-name="$DRUPAL_ADMIN_ACCOUNT_NAME" --account-pass="$DRUPAL_ADMIN_ACCOUNT_PASS" --db-url="$DRUPAL_DB_URI"
  chmod -w "$DRUPAL_ROOT/sites/default/settings.php"
fi
