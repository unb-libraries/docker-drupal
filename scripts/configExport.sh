#!/usr/bin/env sh
rm -rf ${DRUPAL_CONFIGURATION_DIR}/*
${DRUSH} config-export --skip-modules=${DRUPAL_CONFIGURATION_EXPORT_SKIP} --destination=${DRUPAL_CONFIGURATION_DIR}
