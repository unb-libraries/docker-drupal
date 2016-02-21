#!/usr/bin/env sh

# Here, we default to using the address from a linked container named 'mysql', falling back to using the
# details provided through MYSQL_HOSTNAME and MYSQL_PORT environment variables.
MYSQL_PORT_3306_TCP_ADDR="${MYSQL_PORT_3306_TCP_ADDR:-$(echo $MYSQL_HOSTNAME)}"
MYSQL_PORT_3306_TCP_PORT="${MYSQL_PORT_3306_TCP_PORT:-$(echo $MYSQL_PORT)}"

# Check to see if MySQL is accepting connections
nc -zw10 ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw10 ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}
  RETVAL=$?
  echo -e "\t Waiting for MySQL server on $MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT..."
  sleep 10
done
