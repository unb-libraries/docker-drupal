#!/usr/bin/env sh
# Move files to app root and site-install/update.

# Check if this is a new deployment.
if [[ ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Tidy up target webroot and transfer the pre-built drupal tree.
  rm -rf ${DRUPAL_ROOT}/*
  rsync -a ${RSYNC_FLAGS} --inplace ${DRUPAL_BUILD_TMPROOT}/ ${DRUPAL_ROOT}/
elif [[ -f /tmp/DRUPAL_DB_LIVE && -f /tmp/DRUPAL_FILES_LIVE ]];
then
  # Site Needs Upgrade
  echo "Database Exists and Files Found. DRUPAL_REBUILD_ON_REDEPLOY=$DRUPAL_REBUILD_ON_REDEPLOY"

  # Ensure the database details are still valid.
  sed -i "s|'host' => '.*',|'host' => '$MYSQL_HOSTNAME',|g" ${DRUPAL_ROOT}/sites/default/settings.php
  sed -i "s|'port' => '[0-9]\{2,4\}',|'port' => '$MYSQL_PORT',|g" ${DRUPAL_ROOT}/sites/default/settings.php

  if [[ "$DRUPAL_REBUILD_ON_REDEPLOY" == "TRUE" ]];
  then
    echo "Transferring tree to webroot.."

    # Transfer the pre-built drupal tree.
    rsync -a ${RSYNC_FLAGS} --inplace --no-perms --no-owner --no-group --delete --exclude=sites/default/files/ --exclude=sites/default/settings.php --exclude=install.php ${DRUPAL_BUILD_TMPROOT}/ ${DRUPAL_ROOT}/

    # Ensure local settings are being applied.
    grep -q -F 'sites/all/settings/base.settings.php' "${DRUPAL_ROOT}/sites/default/settings.php" || echo "require DRUPAL_ROOT . '/sites/all/settings/base.settings.php';" >> "${DRUPAL_ROOT}/sites/default/settings.php"
  fi
else
  # Inconsistency detected, do nothing to avoid data loss.
  echo "[Error] Something seems odd with the Database and Filesystem, cowardly refusing to do anything."
fi
