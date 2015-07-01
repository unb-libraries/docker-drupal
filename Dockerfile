FROM unblibraries/nginx-php
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

RUN apt-get update && apt-get install -y curl drush mysql-client rsync && apt-get clean
RUN service nginx stop

# Move the default make and profile to the tmp directory
RUN mkdir -p /tmp/drupal_build/unblibdefault
ADD build/unblibdefault.makefile /tmp/drupal_build/unblibdefault.makefile
ADD build/settings_override.php /tmp/drupal_build/settings_override.php

ADD build/unblibdefault/unblibdefault.info /tmp/drupal_build/unblibdefault/unblibdefault.info
ADD build/unblibdefault/unblibdefault.install /tmp/drupal_build/unblibdefault/unblibdefault.install
ADD build/unblibdefault/unblibdefault.profile /tmp/drupal_build/unblibdefault/unblibdefault.profile

# Add Conf File
ADD conf/drupal.conf /etc/nginx/sites-available/default

# Build The Site
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/bin/bash", "/start.sh"]
