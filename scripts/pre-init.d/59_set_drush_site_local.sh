#!/usr/bin/env sh
# Update the copy of global drush and drupal to use the current site-local.
rm -f /usr/bin/drush
ln -s ${DRUPAL_ROOT}/vendor/bin/drush /usr/bin/drush
rm -f /usr/bin/drupal
ln -s ${DRUPAL_ROOT}/vendor/bin/drupal /usr/bin/drupal
