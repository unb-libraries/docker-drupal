#!/usr/bin/env sh
# Get ULI Output.
if [ -z "$1" ]; then
  ULI_OUTPUT=$($DRUSH --no-browser user:login)
else
  ULI_OUTPUT=$($DRUSH --yes --no-browser user:login --name="$1")
fi

# Substitute in local URI if it exists. Otherwise, output link with 'default'.
if [ -z "$DEV_WEB_URI" ]; then
  echo "$ULI_OUTPUT"
else
  echo "$ULI_OUTPUT" | sed -e "s|http://default|$DEV_WEB_URI|g"
fi
