#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes --destination=modules/contrib dl devel
  drush --root=${DRUPAL_ROOT} --uri=default --yes en devel field_ui views_ui
  curl https://drupalconsole.com/installer -L -o /usr/local/bin/drupal && chmod +x /usr/local/bin/drupal && /usr/local/bin/drupal init && /usr/local/bin/drupal check
  mkdir -p ${DRUSH_MAKE_TMPROOT}/modules/contrib
  rsync -a --progress --no-perms --no-owner --no-group ${DRUPAL_ROOT}/modules/contrib/devel ${DRUSH_MAKE_TMPROOT}/modules/contrib
elif [ "$DEPLOY_ENV" = "prod" ]; then
  drush --root=${DRUPAL_ROOT} --uri=default --yes pm-uninstall devel field_ui views_ui dblog
fi
