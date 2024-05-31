#!/usr/bin/env sh
rm /scripts/pre-init.cron.d/94_drupal_cron.sh
/scripts/drupalCronEntry.sh

/scripts/exportData.sh /snapshot
