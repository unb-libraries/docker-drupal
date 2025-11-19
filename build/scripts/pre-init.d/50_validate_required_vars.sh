#!/usr/bin/env sh
# Validate required environment variables before container initialization.

# Check database connection variables
if [ -z "$DRUPAL_DB_HOSTNAME" ]; then
 echo 'ERROR: Database hostname has not been set in $DRUPAL_DB_HOSTNAME'
 exit 1
fi

if [ -z "$DRUPAL_DB_PORT" ]; then
 echo 'ERROR: Database port has not been set in $DRUPAL_DB_PORT'
 exit 1
fi

if [ -z "$DRUPAL_DB_NAME" ]; then
 echo 'ERROR: Database name has not been set in $DRUPAL_DB_NAME'
 exit 1
fi

if [ -z "$DRUPAL_DB_USER" ]; then
 echo 'ERROR: Database user has not been set in $DRUPAL_DB_USER'
 exit 1
fi

if [ -z "$DRUPAL_DB_PASSWORD" ]; then
 echo 'ERROR: Database password has not been set in $DRUPAL_DB_PASSWORD'
 exit 1
fi

# Check Drupal Site ID
if [ -z "$DRUPAL_SITE_ID" ]; then
 echo 'ERROR: Drupal site ID has not been set in $DRUPAL_SITE_ID'
 exit 1
fi
