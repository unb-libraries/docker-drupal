#!/usr/bin/env bash

# Here, we default to using the address from a linked container named 'mysql', falling back to using the
# details provided through MYSQL_HOSTNAME and MYSQL_PORT environment variables.
MYSQL_PORT_3306_TCP_ADDR="${MYSQL_PORT_3306_TCP_ADDR:-$(echo $MYSQL_HOSTNAME)}"
MYSQL_PORT_3306_TCP_PORT="${MYSQL_PORT_3306_TCP_PORT:-$(echo $MYSQL_PORT)}"

# Remove old file markers to eliminate false positives
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

# Check if the Drupal database has been populated with data.
RESULT=`mysqlshow -h ${MYSQL_PORT_3306_TCP_ADDR} -P ${MYSQL_PORT_3306_TCP_PORT} --user=${DRUPAL_SITE_ID}_user --password=$DRUPAL_DB_PASSWORD | grep -v Wildcard | grep -o ${DRUPAL_SITE_ID}_db`
if [ "$RESULT" == "${DRUPAL_SITE_ID}_db" ]; then
  touch /tmp/DRUPAL_DB_LIVE
fi

# Determine if the site was previously built by checking for a settings.php file.
if [ -f ${DRUPAL_ROOT}/sites/default/settings.php ]; then
  touch /tmp/DRUPAL_FILES_LIVE
fi
