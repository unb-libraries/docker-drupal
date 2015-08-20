FROM unblibraries/apache-php
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

ENV DRUSH_VERSION 7.x
ENV DRUPAL_ROOT $WEBTREE_WEBROOT

RUN apt-get update && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y git curl \
  mysql-client rsync && \
  apt-get clean

CMD ["/sbin/my_init"]

# Install Drush
RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush && \
  cd /usr/local/src/drush && \
  git checkout ${DRUSH_VERSION} && \
  ln -s /usr/local/src/drush/drush /usr/bin/drush && \
  composer install

# Add Apache conf.
ADD conf/apache2/default.conf /etc/apache2/sites-available/000-default.conf

# Move the default make and profile to the tmp directory
RUN mkdir -p /tmp/drupal_build/unblibdef
ADD build/unblibdef.makefile /tmp/drupal_build/unblibdef.makefile
ADD build/settings_override.php /tmp/drupal_build/settings_override.php

ADD build/unblibdef/unblibdef.info /tmp/drupal_build/unblibdef/unblibdef.info
ADD build/unblibdef/unblibdef.install /tmp/drupal_build/unblibdef/unblibdef.install
ADD build/unblibdef/unblibdef.profile /tmp/drupal_build/unblibdef/unblibdef.profile

# Add PHP conf.
ADD conf/php5/apache2/php.ini /etc/php5/apache2/php.ini

ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/my_init.d/*.sh
