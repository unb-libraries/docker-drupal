#!/usr/bin/env bash

# Triage request
rm -rf /tmp/DRUPAL_DB_LIVE
rm -rf /tmp/DRUPAL_FILES_LIVE

RESULT=`mysqlshow -h $MYSQL_HOSTNAME --user=${DRUPAL_SITE_ID}_user --password=$DRUPAL_DB_PASSWORD| grep -v Wildcard | grep -o ${DRUPAL_SITE_ID}_db`
if [ "$RESULT" == "${DRUPAL_SITE_ID}_db" ]; then
  touch /tmp/DRUPAL_DB_LIVE
fi

if [ ! -e ${DRUPAL_ROOT}/sites/default/settings.php ]; then
  touch /tmp/DRUPAL_FILES_LIVE
fi

