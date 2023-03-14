#!/usr/bin/env sh
# Get ULI Output.
if [ -z "$1" ]; then
  ULI_OUTPUT=$($DRUSH --no-browser user:login)
else
  ULI_OUTPUT=$($DRUSH --yes --no-browser user:login --uid="$1")
fi

# Substitute in environment URIs, otherwise output link with 'default'.
if [ "$DEPLOY_ENV" = "local" ]; then
  echo "$ULI_OUTPUT" | sed -e "s|http://default|http://$LOCAL_HOSTNAME:$LOCAL_PORT|g"
elif [ "$DEPLOY_ENV" = "dev" ]; then
  echo "$ULI_OUTPUT" | sed -e "s|http://default|http://$DEPLOY_ENV-$DRUPAL_SITE_URI|g"
elif [ "$DEPLOY_ENV" = "prod" ]; then
  echo "$ULI_OUTPUT" | sed -e "s|http://default|http://$DRUPAL_SITE_URI|g"
else
  echo "$ULI_OUTPUT"
fi
