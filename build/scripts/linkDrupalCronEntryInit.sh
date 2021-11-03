#!/usr/bin/env sh
mkdir -p /scripts/pre-init.cron.d

# Log start time.
ln -s /scripts/pre-init.d/01_log_start_time.sh /scripts/pre-init.cron.d/

# Init scripts necessary to bootstrap Drupal.
ln -s /scripts/pre-init.d/52_process_container_yaml.sh /scripts/pre-init.cron.d/
ln -s /scripts/pre-init.d/52_process_settings.sh /scripts/pre-init.cron.d/
ln -s /scripts/pre-init.d/53_process_settings_tokens.sh /scripts/pre-init.cron.d/
ln -s /scripts/pre-init.d/55_wait_for_mysql_server.sh /scripts/pre-init.cron.d/
ln -s /scripts/pre-init.d/61_apply_drupal_settings.sh /scripts/pre-init.cron.d/
ln -s /scripts/pre-init.d/71_set_public_file_permissions.sh /scripts/pre-init.cron.d/
ln -s /scripts/pre-init.d/72_secure_config_sync_dir.sh /scripts/pre-init.cron.d/

# Run cron.
ln -s /scripts/drupalCron.sh /scripts/pre-init.cron.d/95_drupal_cron.sh

# Here is an appropriate time to Run any pending queues.
# (Tip! To find queues, search source trees for '@QueueWorker')
# Ex : drush queue-run traf_sys_import
# List queues with : drush queue-list

# Report run time.
ln -s /scripts/pre-init.d/99_z_report_completion.sh /scripts/pre-init.cron.d/
