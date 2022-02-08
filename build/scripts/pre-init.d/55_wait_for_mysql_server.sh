#!/usr/bin/env sh
# Check if MySQL vars are set and then test the connection.

# Check if MySQL env vars exist.
if [ -z "$MYSQL_HOSTNAME" ]; then
 echo 'A MySQL server IP address has not been set in $MYSQL_HOSTNAME'
 exit 1
fi

if [ -z "$MYSQL_PORT" ]; then
 echo 'A MySQL server port has not been set in $MYSQL_PORT'
 exit 1
fi

# Check to see if MySQL is accepting connections
nc -zw1 "$MYSQL_HOSTNAME" "$MYSQL_PORT"
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw1 "$MYSQL_HOSTNAME" "$MYSQL_PORT"
  RETVAL=$?
  echo -e "\t Waiting for MySQL server on $MYSQL_HOSTNAME:$MYSQL_PORT..."
  sleep 1
done
