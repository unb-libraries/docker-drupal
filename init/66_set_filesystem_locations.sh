#!/usr/bin/env bash

cd /usr/share/nginx/html
drush --yes vset file_temporary_path /tmp
