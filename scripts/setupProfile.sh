#!/usr/bin/env sh
set -e

# Deploy profile to drupal tree.
mv /build/profile/profile.info.yml /build/profile/${DRUPAL_SITE_ID}.info.yml
mv /build/profile/profile.install /build/profile/${DRUPAL_SITE_ID}.install
mv /build/profile/profile.profile /build/profile/${DRUPAL_SITE_ID}.profile
find /build/profile/ -type f -print0 | xargs -0 sed -i "s/PROFILE_SLUG/$DRUPAL_SITE_ID/g"
mv /build/profile /build/${DRUPAL_SITE_ID}
