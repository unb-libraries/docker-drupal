#!/usr/bin/env bash

# Triage request
rm -rf /tmp/DB_LIVE
rm -rf /tmp/FILES_LIVE

RESULT=`mysqlshow -h $MYSQL_HOSTNAME --user=${DRUPAL_SITE_ID}_user --password=$DRUPAL_DB_PASSWORD| grep -v Wildcard | grep -o ${DRUPAL_SITE_ID}_db`
if [ "$RESULT" == "${DRUPAL_SITE_ID}_db" ]; then
  touch /tmp/DB_LIVE
fi

if [ ! -e ${DRUPAL_ROOT}/sites/default/settings.php ]; then
  touch /tmp/FILES_LIVE
fi

