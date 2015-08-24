#!/usr/bin/env bash

# Wait for MySQL server to be ready.
nc -zw10 ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
   nc -zw10 ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}
   RETVAL=$?
   echo -e "\t Waiting for MySQL server on $MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT..."
   sleep 10
done
