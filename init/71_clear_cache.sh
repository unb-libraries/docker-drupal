#!/usr/bin/env bash

cd /usr/share/nginx/html
/sbin/setuser www-data drush --yes cc all

