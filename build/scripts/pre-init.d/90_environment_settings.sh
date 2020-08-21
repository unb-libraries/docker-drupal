#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "prod" ]; then
  echo "Ensuring some modules are disabled in production..."
  ${DRUSH} pm-uninstall devel field_ui views_ui dblog  > /dev/null 2>&1
fi
