#!/usr/bin/env sh
# Validate required environment variables before container initialization.
. /scripts/lib/validation.sh

# Database connection variables
require_env DRUPAL_DB_HOSTNAME "Database hostname"
require_env DRUPAL_DB_PORT "Database port"
require_env DRUPAL_DB_NAME "Database name"
require_env DRUPAL_DB_USER "Database user"
require_env DRUPAL_DB_PASSWORD "Database password"
require_env DRUPAL_DB_DRIVER "Database driver"
require_env_defined DRUPAL_DB_PREFIX "Database prefix"

# Drupal site identifier
require_env DRUPAL_SITE_ID "Drupal site ID"
