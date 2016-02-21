#!/usr/bin/env sh

drush --yes --root=${DRUPAL_ROOT} --uri=default vset file_temporary_path /tmp
