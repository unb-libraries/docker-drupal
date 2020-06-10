#!/usr/bin/env sh

# Dev/NoDev
DRUPAL_COMPOSER_DEV="${1:-no-dev}"

# Dev Addons.
echo "DRUPAL_COMPOSER_DEV = $DRUPAL_COMPOSER_DEV"

# Blackfire/NoBlackfire.
INSTALL_BLACKFIRE_PROBE="${2:-FALSE}"

echo "INSTALL_BLACKFIRE_PROBE = $INSTALL_BLACKFIRE_PROBE"
if [ "$INSTALL_BLACKFIRE_PROBE" == "TRUE" ]; then
  echo "Installing Blackfire Probe..."
  /scripts/installBlackfireProbe.sh

  echo "Installing Blackfire CLI..."
  /scripts/installBlackfireCli.sh
fi
