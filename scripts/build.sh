#!/usr/bin/env sh
set -e

/scripts/buildDrupalTree.sh
/scripts/installNewRelic.sh
/scripts/cleanupBuild.sh
