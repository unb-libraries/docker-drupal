FROM unblibraries/nginx-php
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

RUN apt-get update && \
  apt-get install -y git curl drush mysql-client rsync && apt-get clean

CMD ["/sbin/my_init"]

# Move the default make and profile to the tmp directory
RUN mkdir -p /tmp/drupal_build/unblibdef
ADD build/unblibdef.makefile /tmp/drupal_build/unblibdef.makefile
ADD build/settings_override.php /tmp/drupal_build/settings_override.php

ADD build/unblibdef/unblibdef.info /tmp/drupal_build/unblibdef/unblibdef.info
ADD build/unblibdef/unblibdef.install /tmp/drupal_build/unblibdef/unblibdef.install
ADD build/unblibdef/unblibdef.profile /tmp/drupal_build/unblibdef/unblibdef.profile

# Add Conf File
ADD conf/drupal.conf /etc/nginx/sites-available/default

ADD init/60_build_drupal_tree.sh /etc/my_init.d/60_build_drupal_tree.sh
ADD init/65_transfer_remote_filesystem.sh /etc/my_init.d/65_transfer_remote_filesystem.sh
ADD init/70_set_permissions.sh /etc/my_init.d/70_set_permissions.sh
ADD init/71_clear_cache.sh /etc/my_init.d/71_clear_cache.sh
RUN chmod -v +x /etc/my_init.d/*.sh
