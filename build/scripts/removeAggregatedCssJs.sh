#!/usr/bin/env sh
rm -f "$DRUPAL_ROOT/sites/default/files/css/"*.css 2>/dev/null || true
rm -f "$DRUPAL_ROOT/sites/default/files/js/"*.js 2>/dev/null || true
