#!/usr/bin/env sh
# Serves as an entrypoint for containers to run cron only.
/scripts/pre-init.d/01_log_start_time.sh

# Enable E-Mail
/scripts/pre-init.d/20_enable_postfix.sh

# If they exist, remove references to newrelic.
rm -f /etc/php7/conf.d/newrelic.ini

# Run init scripts necessary to bootstrap Drupal.
/scripts/pre-init.d/52_process_container_yaml.sh
/scripts/pre-init.d/52_process_settings.sh
/scripts/pre-init.d/55_wait_for_mysql_server.sh
/scripts/pre-init.d/61_apply_drupal_settings.sh
/scripts/pre-init.d/71_set_public_file_permissions.sh
/scripts/pre-init.d/72_secure_config_sync_dir.sh

# Run cron.
/scripts/drupalCron.sh

# Run any pending queues.
# (Tip! To find queues, search trees for '@QueueWorker')
# Ex : drush queue-run traf_sys_import

# Flush postfix.
/scripts/flushEmailsFromPostfix.sh

# Report run time.
START_TIME=`cat /tmp/start_time`
NOW=`date +%s`
STARTUP_TIME=`expr $NOW - $START_TIME`

echo "Cron Run Time: ${STARTUP_TIME}s"
