#!/usr/bin/env bash

cd ${DRUPAL_ROOT}
drush --yes vset file_temporary_path /tmp
