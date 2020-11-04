#!/usr/bin/env sh

# nginx
mv /build/nginx/* /etc/nginx/conf.d/

# php
mv /build/php/app-php.ini /etc/php7/conf.d/zz_app.ini
mv /build/php/app-php-fpm.conf /etc/php7/php-fpm.d/zz_app.conf

# postfix
cat /build/postfix/main.cf >> /etc/postfix/main.cf
