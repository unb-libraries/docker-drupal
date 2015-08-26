#!/usr/bin/env bash

MYSQL_PORT_3306_TCP_ADDR="${MYSQL_PORT_3306_TCP_ADDR:-$(echo $MYSQL_HOSTNAME)}"
MYSQL_PORT_3306_TCP_PORT="${MYSQL_PORT_3306_TCP_PORT:-$(echo $MYSQL_PORT)}"

# Triage request
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

RESULT=`mysqlshow -h ${MYSQL_PORT_3306_TCP_ADDR} -P ${MYSQL_PORT_3306_TCP_PORT} --user=${DRUPAL_SITE_ID}_user --password=$DRUPAL_DB_PASSWORD | grep -v Wildcard | grep -o ${DRUPAL_SITE_ID}_db`
if [ "$RESULT" == "${DRUPAL_SITE_ID}_db" ]; then
  touch /tmp/DRUPAL_DB_LIVE
fi

if [ -f ${DRUPAL_ROOT}/sites/default/settings.php ]; then
  touch /tmp/DRUPAL_FILES_LIVE
fi

