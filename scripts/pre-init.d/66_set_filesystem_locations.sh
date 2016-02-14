#!/usr/bin/env bash

drush --yes --root=${DRUPAL_ROOT} --uri=default vset file_temporary_path /tmp
