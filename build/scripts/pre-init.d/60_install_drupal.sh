#!/usr/bin/env sh
# Check if this is a new deployment. If so, install.
if [ ! -f /tmp/DRUPAL_DB_LIVE ] && [ ! -f /tmp/DRUPAL_FILES_LIVE ];
then
  echo "Performing new Drupal installation..."

  # Validate required variables for new installation
  if [ -z "$DRUPAL_ADMIN_ACCOUNT_PASS" ]; then
    echo 'ERROR: Drupal admin password has not been set in $DRUPAL_ADMIN_ACCOUNT_PASS'
    exit 1
  fi

  if [ -z "$DRUPAL_SITE_URI" ]; then
    echo 'ERROR: Drupal site URI has not been set in $DRUPAL_SITE_URI'
    exit 1
  fi

  # Deploys the sites/default tree if removed by a local volume.
  rsync -a /tmp/default "$DRUPAL_ROOT/sites/"
  chown -R "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" "$DRUPAL_ROOT/sites/default"

  # If MYSQL_ROOT_PASSWORD is specified, we can create the database/user.
  # This is a hidden magic feature for local.
  # Do not use this in production!
  if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
    echo "Creating Drupal database and user..."
    mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$DRUPAL_DB_HOSTNAME" -P "$DRUPAL_DB_PORT" -e "DROP DATABASE IF EXISTS $DRUPAL_DB_NAME; CREATE DATABASE $DRUPAL_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci; CREATE USER '$DRUPAL_DB_USER'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; GRANT ALL PRIVILEGES ON $DRUPAL_DB_NAME.* TO '$DRUPAL_DB_USER'@'%' IDENTIFIED BY '$DRUPAL_DB_PASSWORD'; FLUSH PRIVILEGES;"
  else
    echo "MYSQL_ROOT_PASSWORD not specified, skipping database/user creation."
  fi

  # Creates the database structure for an empty site via Drush.
  cd "$DRUPAL_ROOT" || exit

  SETTINGS_FILE="$DRUPAL_ROOT/sites/default/settings.php"
  if [ -f "$SETTINGS_FILE" ]; then
      chmod +w "$SETTINGS_FILE"
  fi

  PHP_SET_SENDMAIL_NOWHERE="/usr/bin/env PHP_OPTIONS=\"-d sendmail_path=`which true`\""
  DRUPAL_DB_URI="mysql://$DRUPAL_DB_USER:$DRUPAL_DB_PASSWORD@$DRUPAL_DB_HOSTNAME:$DRUPAL_DB_PORT/$DRUPAL_DB_NAME"
  $PHP_SET_SENDMAIL_NOWHERE $DRUSH site-install minimal --verbose --account-name="$DRUPAL_ADMIN_ACCOUNT_NAME" --account-pass="$DRUPAL_ADMIN_ACCOUNT_PASS" --db-url="$DRUPAL_DB_URI" --site-name="$DRUPAL_SITE_URI"
  chmod -w "$DRUPAL_ROOT/sites/default/settings.php"
fi
