#!/usr/bin/env sh

sed -i "s|APP_HOSTNAME|$APP_HOSTNAME|g" /etc/postfix/main.cf
