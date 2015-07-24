#!/usr/bin/env bash

if [[ -n "$DRUSH_TRANSFER_KEY" && -n "$DRUSH_TRANSFER_USER" && -n "$DRUSH_TRANSFER_HOST" && -n "$DRUSH_TRANSFER_PATH" && -n "$DRUSH_TRANSFER_URI" ]] ; then

cat <<EOT >> /tmp/remote_site.php
$aliases['remote_site'] = array(
  'uri' => '$DRUSH_TRANSFER_URI',
  'root' => '$DRUSH_TRANSFER_PATH',
  'remote-user' => '$DRUSH_TRANSFER_USER',
  'remote-host' => '$DRUSH_TRANSFER_HOST',
  'ssh-options' => '-o PasswordAuthentication=no -i /home/YOURUSERNAME/.ssh/id_rsa',
);
EOT

fi


# * @file yoursite.aliases.drushrc.php
# * Site aliases for [your site domain]
# * Place this file at ~/.drush/ 
#
# /**
# * Production alias
#
#
# drush --root=#{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']} --uri=default rsync @#{node['unblibraries-drupal']['deploy-uri']}:%files @self:%files --omit-dir-times --no-p --no-o --exclude-paths="css:js:styles:imagecache:ctools:tmp"

# Change File Path Permissions (TODO : Drush?)
# chmod -R 777 #{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']}/sites/default/files

# Transfer live DB to Local
# drush --root=#{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']} --uri=default sql-sync @#{node['unblibraries-drupal']['deploy-uri']} @self

# Set filepath var
# drush --root=#{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']} --uri=default vset file_public_path sites/default/files
# drush --root=#{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']} --uri=default vset file_private_path sites/default/files
# drush --root=#{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']} --uri=default vset file_temporary_path /tmp

# Rebuild Registry
# drush --root=#{node['unblibraries-drupal']['deploy-path']}/#{node['unblibraries-drupal']['deploy-dir-name']} --uri=default registry-rebuild
