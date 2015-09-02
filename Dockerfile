FROM unblibraries/apache-php
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

ENV DRUPAL_ADMIN_ACCOUNT_NAME admin
ENV DRUPAL_ADMIN_ACCOUNT_PASS admin
ENV DRUPAL_ROOT $WEBTREE_WEBROOT
ENV DRUPAL_SITE_ID unblibdef
ENV DRUSH_MAKE_CONCURRENCY 5
ENV DRUSH_MAKE_OPTIONS="--shallow-clone"
ENV DRUSH_VERSION 7.x
ENV WEBSERVER_USER_ID 33

RUN apt-get update && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y git curl \
  mysql-client rsync && \
  apt-get clean

# Install Drush
RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush && \
  cd /usr/local/src/drush && \
  git checkout ${DRUSH_VERSION} && \
  ln -s /usr/local/src/drush/drush /usr/bin/drush && \
  composer install

# Add Apache conf.
ADD conf/apache2/default.conf /etc/apache2/sites-available/000-default.conf

# Deploy the default makefile and install profile to the container
RUN mkdir -p /tmp/drupal_build/${DRUPAL_SITE_ID}
ADD build/${DRUPAL_SITE_ID}.makefile /tmp/drupal_build/${DRUPAL_SITE_ID}.makefile
ADD build/settings_override.php /tmp/drupal_build/settings_override.php

ADD build/${DRUPAL_SITE_ID}/${DRUPAL_SITE_ID}.info /tmp/drupal_build/${DRUPAL_SITE_ID}/${DRUPAL_SITE_ID}.info
ADD build/${DRUPAL_SITE_ID}/${DRUPAL_SITE_ID}.install /tmp/drupal_build/${DRUPAL_SITE_ID}/${DRUPAL_SITE_ID}.install
ADD build/${DRUPAL_SITE_ID}/${DRUPAL_SITE_ID}.profile /tmp/drupal_build/${DRUPAL_SITE_ID}/${DRUPAL_SITE_ID}.profile

# Add PHP conf.
ADD conf/php5/apache2/php.ini /etc/php5/apache2/php.ini

CMD ["/sbin/my_init"]
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/my_init.d/*.sh
