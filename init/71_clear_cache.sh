#!/usr/bin/env bash

cd /usr/share/nginx/html
/sbin/setuser www-run drush yes cc all

