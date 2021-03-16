#!/usr/bin/env sh
# Serves as an entrypoint for containers to run cron only.
/scripts/pre-init.d/01_log_start_time.sh

# If they exist, remove references to newrelic.
rm -f /etc/php7/conf.d/newrelic.ini

# Run init scripts necessary to bootstrap Drupal.
/scripts/pre-init.d/52_process_container_yaml.sh
/scripts/pre-init.d/52_process_settings.sh
/scripts/pre-init.d/55_wait_for_mysql_server.sh

# Run cron.
/scripts/drupalCron.sh

# Report run time.
START_TIME=`cat /tmp/start_time`
NOW=`date +%s`
STARTUP_TIME=`expr $NOW - $START_TIME`

echo "Cron Run Time: ${STARTUP_TIME}s"
