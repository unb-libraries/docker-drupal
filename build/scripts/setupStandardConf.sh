#!/usr/bin/env sh

# nginx
$RSYNC_MOVE /build/nginx/ "$NGINX_CONFD_DIR/"

# php
# nginx-php provides the canonical zz_app.ini / zz_app.conf (incl. logging keys
# and catch_workers_output). These are optional Drupal/site overrides:
#  - app-php.ini installs ADDITIVELY as zz_drupal.ini (loads after zz_app.ini,
#    so Drupal-specific ini values win without clobbering nginx-php's logging).
#  - app-php-fpm.conf, if present, REPLACES zz_app.conf (a duplicate [app] pool
#    would error); absent by default so nginx-php's pool is inherited.
[ -f /build/php/app-php.ini ]      && mv /build/php/app-php.ini      "$PHP_CONFD_DIR/zz_drupal.ini"
[ -f /build/php/app-php-fpm.conf ] && mv /build/php/app-php-fpm.conf "$PHP_FPM_CONFD_DIR/zz_app.conf"

# postfix
cat /build/postfix/main.cf >> /etc/postfix/main.cf
