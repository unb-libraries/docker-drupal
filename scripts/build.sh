#!/usr/bin/env sh
set -e

# Profile ID
DRUPAL_BASE_PROFILE="${1:-minimal}"

/scripts/setupProfile.sh
/scripts/buildDrupalTree.sh ${DRUPAL_BASE_PROFILE}
/scripts/installNewRelic.sh
/scripts/cleanupBuild.sh
