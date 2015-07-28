FROM unblibraries/nginx-php
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

RUN apt-get update && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y git curl drush \
  mysql-client rsync && \
  apt-get clean

CMD ["/sbin/my_init"]

# Move the default make and profile to the tmp directory
RUN mkdir -p /tmp/drupal_build/unblibdef
ADD build/unblibdef.makefile /tmp/drupal_build/unblibdef.makefile
ADD build/settings_override.php /tmp/drupal_build/settings_override.php

ADD build/unblibdef/unblibdef.info /tmp/drupal_build/unblibdef/unblibdef.info
ADD build/unblibdef/unblibdef.install /tmp/drupal_build/unblibdef/unblibdef.install
ADD build/unblibdef/unblibdef.profile /tmp/drupal_build/unblibdef/unblibdef.profile

# Add Conf File
ADD conf/nginx/drupal.conf /etc/nginx/sites-available/default

ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/my_init.d/*.sh
