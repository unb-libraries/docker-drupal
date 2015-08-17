#!/usr/bin/env bash
  
cd ${WEBTREE_ROOT}
chown root:root -R html
chown www-data:www-data -R html/sites/default/files
chown root:root html/sites/default/files/.htaccess

