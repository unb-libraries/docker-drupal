#!/usr/bin/env bash

if [[ -n "$DRUSH_TRANSFER_KEY" && -n "$DRUSH_TRANSFER_USER" && -n "$DRUSH_TRANSFER_HOST" && -n "$DRUSH_TRANSFER_PATH" && -n "$DRUSH_TRANSFER_URI" && ! -f /tmp/DB_LIVE && ! -f /tmp/FILES_LIVE ]] ; then

  cat <<EOT >> /tmp/remote_auth_key
$DRUSH_TRANSFER_KEY
EOT
  chmod 0600 /tmp/remote_auth_key
  
  mkdir /tmp/drush-aliases
  cat <<EOT >> /tmp/drush-aliases/aliases.drushrc.php
<?php
\$aliases['live'] = array(
  'uri' => '$DRUSH_TRANSFER_URI',
  'root' => '$DRUSH_TRANSFER_PATH',
  'remote-user' => '$DRUSH_TRANSFER_USER',
  'remote-host' => '$DRUSH_TRANSFER_HOST',
  'ssh-options' => '-o PasswordAuthentication=no -o StrictHostKeyChecking=no -i /tmp/remote_auth_key',
);
EOT

  if [[ $(drush @live status --alias-path=/tmp/drush-aliases) =~ "Successful" ]]; then
    DRUSH_BIN='drush --yes --verbose --alias-path=/tmp/drush-aliases --uri=default'
    cd ${DRUPAL_ROOT}
    $DRUSH_BIN @live status
    $DRUSH_BIN rsync @live:%files @self:%files --omit-dir-times --no-p --no-o --exclude-paths="css:js:styles:imagecache:ctools:tmp"
    $DRUSH_BIN sql-sync @live @self
  fi

fi

