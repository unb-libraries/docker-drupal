#!/usr/bin/env bash

MYSQL_PORT_3306_TCP_ADDR="${MYSQL_PORT_3306_TCP_ADDR:-$(echo $MYSQL_HOSTNAME)}"
MYSQL_PORT_3306_TCP_PORT="${MYSQL_PORT_3306_TCP_PORT:-$(echo $MYSQL_PORT)}"

nc -zw10 ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
   nc -zw10 ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}
   RETVAL=$?
   echo -e "\t Waiting for MySQL server on $MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT..."
   sleep 10
done
