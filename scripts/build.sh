#!/usr/bin/env sh
set -e

# Dev/NoDev
DRUPAL_COMPOSER_DEV="${1:-no-dev}"

# Profile ID
DRUPAL_BASE_PROFILE="${2:-minimal}"

/scripts/setupProfile.sh
/scripts/buildDrupalTree.sh ${COMPOSER_DEPLOY_DEV} ${DRUPAL_BASE_PROFILE}
/scripts/installNewRelic.sh
/scripts/installDevTools.sh ${COMPOSER_DEPLOY_DEV}
/scripts/cleanupBuild.sh ${COMPOSER_DEPLOY_DEV}
