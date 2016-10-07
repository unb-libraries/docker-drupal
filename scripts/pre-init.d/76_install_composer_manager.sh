#!/usr/bin/env sh
# Local alterations for your instance.
# i.e. drush --root=${DRUPAL_ROOT} --uri=default --yes en thirty_two_project
if [ "$DRUPAL_COMPOSER_MANAGER_DEPLOY" != "FALSE" ]; then
  cd ${DRUPAL_ROOT}
  ls
  drush --root=${DRUPAL_ROOT} --uri=default --yes en --destination=modules/contrib composer_manager
  php -f modules/contrib/composer_manager/scripts/init.php
  drush --root=${DRUPAL_ROOT} --uri=default --yes en ${DRUPAL_MODULES_TO_ENABLE}
  composer drupal-update
fi
