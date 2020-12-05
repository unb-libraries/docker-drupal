#!/usr/bin/env sh
# Serves as an entrypoint for containers to run cron only.

# If they exist, remove references to newrelic.
rm -f /etc/php7/conf.d/newrelic.ini

# Run init scripts necessary to bootstrap Drupal.
/scripts/pre-init.d/01_log_start_time.sh
/scripts/pre-init.d/52_process_container_yaml.sh
/scripts/pre-init.d/52_process_settings.sh
/scripts/pre-init.d/55_wait_for_mysql_server.sh
/scripts/pre-init.d/99_z_report_startup_time.sh

# Run cron.
/scripts/drupalCron.sh
