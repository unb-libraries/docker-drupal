#!/usr/bin/env sh
du -sb "$DRUPAL_ROOT/sites/default" | awk '{print $1}'
