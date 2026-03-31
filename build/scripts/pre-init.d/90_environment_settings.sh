#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "prod" ]; then
  FORBID_MODULES="devel field_ui views_ui dblog"
  for MODULE in $FORBID_MODULES; do
    if ${DRUSH} pm:list --status=enabled --type=module --format=list | grep -q "^$MODULE$"; then
      echo "Error: Module '$MODULE' is enabled in production environment. Please disable it before deploying."
      exit 1
    fi
  done
fi
