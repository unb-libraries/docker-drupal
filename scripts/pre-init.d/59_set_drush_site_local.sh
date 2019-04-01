#!/usr/bin/env sh
# Update the copy of global drush to use the site-local.
rm -f /usr/bin/drush
ln -s /app/html/vendor/bin/drush /usr/bin/drush

# Set the DRUSH_COMMAND for further execution.
export DRUSH_COMMAND="sudo -u ${NGINX_RUN_USER} -g ${NGINX_RUN_GROUP} -- drush --root=${DRUPAL_ROOT} --uri=default --yes"
