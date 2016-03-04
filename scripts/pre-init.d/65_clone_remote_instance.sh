#!/usr/bin/env sh
# Transfer data from a remote site to the local instance.
# Convert your private key to an ENV compatible string with "cat private_key | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g'"

# Ensure that all details are provided and this is the a first time deployment. Otherwise, skip this.
if [[ -n "$DRUSH_TRANSFER_KEY" && -n "$DRUSH_TRANSFER_USER" && -n "$DRUSH_TRANSFER_HOST" && -n "$DRUSH_TRANSFER_PATH" && -n "$DRUSH_TRANSFER_URI" && ! -f /tmp/DRUPAL_DB_LIVE && ! -f /tmp/DRUPAL_FILES_LIVE ]] ; then
  echo "Cloning Remote Instance.."
  # Write remote auth key to a temporary location and set appropriate permissions.
  cat <<EOT >> /tmp/remote_auth_key
$DRUSH_TRANSFER_KEY
EOT
  chmod 0600 /tmp/remote_auth_key

  # Create an alias file for drush to use.
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

  # Install openssh-client
  apk --update add openssh-client

  # If we can access the site and drush reports a normal status, then transfer the data.
  if [[ $(drush @live status --alias-path=/tmp/drush-aliases) =~ "Successful" ]]; then
    DRUSH_BIN='drush --yes --verbose --alias-path=/tmp/drush-aliases --uri=default'
    cd ${DRUPAL_ROOT}
    $DRUSH_BIN @live status
    $DRUSH_BIN rsync @live:%files @self:%files --omit-dir-times --no-p --no-o --exclude-paths="css:js:styles:imagecache:ctools:tmp"
    $DRUSH_BIN rsync @live:%modules @self:%modules --omit-dir-times --no-p --no-o
    $DRUSH_BIN rsync @live:%themes @self:%themes --omit-dir-times --no-p --no-o
    $DRUSH_BIN sql-sync @live @self
    $DRUSH_BIN cc all
  fi
fi
