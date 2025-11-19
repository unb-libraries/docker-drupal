#!/usr/bin/env sh
# Test the database connection and wait for it to be available.

# Check to see if database is accepting connections
nc -zw1 "$DRUPAL_DB_HOSTNAME" "$DRUPAL_DB_PORT"
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw1 "$DRUPAL_DB_HOSTNAME" "$DRUPAL_DB_PORT"
  RETVAL=$?
  echo -e "\t Waiting for database server on $DRUPAL_DB_HOSTNAME:$DRUPAL_DB_PORT..."
  sleep 1
done
