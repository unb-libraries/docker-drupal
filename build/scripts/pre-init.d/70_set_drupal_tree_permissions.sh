#!/usr/bin/env sh
# Prevent the web daemon user from modifying drupal tree files.
# Disabled : I believe this is unnecessary.
# find ${DRUPAL_ROOT} -not \( -path "${DRUPAL_ROOT}/sites/default/files" -prune \) -not -user root -not -group root -print0 | xargs -r0 chown root:root --
