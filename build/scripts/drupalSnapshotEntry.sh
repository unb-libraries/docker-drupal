#!/usr/bin/env sh

# Cron is an efficient way to bootstrap Drupal without duplicating code.
# Skipping the cron itself at the end.
rm /scripts/pre-init.cron.d/94_drupal_cron.sh
/scripts/drupalCronEntry.sh

/scripts/exportData.sh /snapshot "$@"
