#!/usr/bin/env bash
  
cd ${WEBTREE_ROOT}
chown root:root -R html
chown ${WEBSERVER_USER_ID}:${WEBSERVER_USER_ID} -R html/sites/default/files
chown root:root html/sites/default/files/.htaccess

