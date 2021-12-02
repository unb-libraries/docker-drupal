#!/usr/bin/env sh
PUBLIC_FILESYSTEM_PATH=$($DRUSH eval "echo \Drupal::service('file_system')->realpath('public://');")
if [ $PUBLIC_FILESYSTEM_PATH ]; then
  echo "Securing public:// [$PUBLIC_FILESYSTEM_PATH]..."
  $DRUSH eval 'use Drupal\Component\FileSecurity\FileSecurity; print FileSecurity::htaccessLines(FALSE)' > ${PUBLIC_FILESYSTEM_PATH}/.htaccess
  chown root:root ${PUBLIC_FILESYSTEM_PATH}/.htaccess
fi

if [ ! -z "$DRUPAL_PRIVATE_FILE_PATH" ]; then
  mkdir -p ${DRUPAL_PRIVATE_FILE_PATH} && chown ${NGINX_RUN_USER}:${NGINX_RUN_GROUP} ${DRUPAL_PRIVATE_FILE_PATH}
  echo "Securing private:// [$DRUPAL_PRIVATE_FILE_PATH]..."
  $DRUSH eval 'use Drupal\Component\FileSecurity\FileSecurity; print FileSecurity::htaccessLines(FALSE)' > ${DRUPAL_PRIVATE_FILE_PATH}/.htaccess
  chown root:root ${DRUPAL_PRIVATE_FILE_PATH}/.htaccess
fi
