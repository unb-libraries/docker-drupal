#!/usr/bin/env sh

# nginx
$RSYNC_MOVE /build/nginx/ "$NGINX_CONFD_DIR/"

# php
mv /build/php/app-php.ini "$PHP_CONFD_DIR/zz_app.ini"
mv /build/php/app-php-fpm.conf "$PHP_FPM_CONFD_DIR/zz_app.conf"

# postfix
cat /build/postfix/main.cf >> /etc/postfix/main.cf
