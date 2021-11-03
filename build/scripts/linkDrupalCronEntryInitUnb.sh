#!/usr/bin/env sh

# Enable Postfix.
ln -s /scripts/pre-init.d/20_enable_postfix.sh /scripts/pre-init.cron.d/

# Disable newrelic logging in cron pods
ln -s /scripts/removeNewRelicIni.sh /scripts/pre-init.cron.d/21_remove_newrelic_ini.sh

# Ensure E-Mail in postfix queue gets sent before pod dies.
ln -s /scripts/flushEmailsFromPostfix.sh /scripts/pre-init.cron.d/98_flush_postfix_queue.sh
