#!/usr/bin/env sh
# Prevent the web daemon user from modifying drupal tree files.
find ${DRUPAL_ROOT} \! -user root \! -group root -not \( -path "${DRUPAL_ROOT}/sites/default/files" -prune \) -print0 | xargs -0 chown root:root --
