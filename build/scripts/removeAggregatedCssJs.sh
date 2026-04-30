#!/usr/bin/env sh
set -e
find "$DRUPAL_ROOT/sites/default/files/css" -maxdepth 1 -type f -name '*.css' -delete 2>/dev/null || true
find "$DRUPAL_ROOT/sites/default/files/js"  -maxdepth 1 -type f -name '*.js'  -delete 2>/dev/null || true
