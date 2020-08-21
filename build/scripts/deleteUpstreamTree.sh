#!/usr/bin/env sh
set -e

# Delete files from parent repo build, allowing a local build.
rm -rf /build
mkdir -p /build

# Remove Drupal console from upstream, installed with site
rm -f /usr/bin/drupal

# Remove upstream tests.
rm -rf ${DRUPAL_TESTING_ROOT}
