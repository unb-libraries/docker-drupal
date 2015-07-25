#!/usr/bin/env bash
  
cd /usr/share/nginx
chown root:root -R html
chown www-data:www-data -R html/sites/default/files
chown root:root html/sites/default/files/.htaccess

