#!/usr/bin/env sh

# nginx
mv /package-conf/nginx/* /etc/nginx/conf.d/

# php
mv /package-conf/php/app-php.ini /etc/php7/conf.d/zz_app.ini
mv /package-conf/php/app-php-fpm.conf /etc/php7/php-fpm.d/zz_app.conf

# postfix
cat /package-conf/postfix/main.cf >> /etc/postfix/main.cf

# logzio
mkdir -p /etc/rsyslog.d
mv /package-conf/rsyslog/21-logzio-nginx.conf /etc/rsyslog.d/21-logzio-nginx.conf
