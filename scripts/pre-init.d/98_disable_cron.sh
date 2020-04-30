#!/usr/bin/env sh
if [ "$DRUPAL_RUN_CRON" != "TRUE" ]; then
  rm -f /etc/periodic/15min/drupalCron
fi
