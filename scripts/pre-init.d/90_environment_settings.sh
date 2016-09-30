#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes --destination=modules/contrib dl devel
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui

  # Install Drupal Console
  cd ${DRUPAL_ROOT}
  composer require drupal/console:~1.0 \
  --prefer-dist \
  --optimize-autoloader \
  --sort-packages
  ln -s /app/html/vendor/bin/drupal /usr/local/bin/drupal

  mkdir -p ${DRUSH_MAKE_TMPROOT}/modules/contrib
  rsync -a --progress --no-perms --no-owner --no-group ${DRUPAL_ROOT}/modules/contrib/devel ${DRUSH_MAKE_TMPROOT}/modules/contrib
elif [ "$DEPLOY_ENV" = "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
