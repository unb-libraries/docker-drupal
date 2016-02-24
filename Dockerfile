FROM unblibraries/nginx-php:alpine
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

ENV DRUPAL_ADMIN_ACCOUNT_NAME admin
ENV DRUPAL_ADMIN_ACCOUNT_PASS admin
ENV DRUPAL_REBUILD_ON_REDEPLOY TRUE
ENV DRUPAL_REVERT_FEATURES FALSE
ENV DRUPAL_ROOT $APP_WEBROOT
ENV DRUPAL_SITE_ID defaultd
ENV DRUSH_MAKE_CONCURRENCY 5
ENV DRUSH_MAKE_OPTIONS="--shallow-clone"
ENV DRUSH_VERSION 8.0.x
ENV TMP_DRUPAL_BUILD_DIR /tmp/drupal_build

RUN apk --update add php-pdo php-pdo_mysql php-pcntl php-dom php-posix php-ctype php-gd php-xml git unzip mysql-client rsync && \
  rm -f /var/cache/apk/*

# Install Drush
RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush && \
  cd /usr/local/src/drush && \
  git checkout ${DRUSH_VERSION} && \
  ln -s /usr/local/src/drush/drush /usr/bin/drush && \
  rm -rf /usr/local/src/drush/.git && \
  composer install

# Add nginx and PHP conf.
COPY conf/nginx/app.conf /etc/nginx/conf.d/app.conf
COPY conf/php/php.ini /etc/php/php.ini
COPY conf/php/php-fpm.conf /etc/php/php-fpm.conf

# Deploy the default makefile and install profile to the container
RUN mkdir -p ${TMP_DRUPAL_BUILD_DIR}
COPY build/ ${TMP_DRUPAL_BUILD_DIR}

# Drush-make the site.
ENV DRUSH_MAKE_TMPROOT ${TMP_DRUPAL_BUILD_DIR}/webroot
RUN drush make --concurrency=${DRUSH_MAKE_CONCURRENCY} --yes ${DRUSH_MAKE_OPTIONS} "${TMP_DRUPAL_BUILD_DIR}/${DRUPAL_SITE_ID}.yml" ${DRUSH_MAKE_TMPROOT} && \
  mv ${TMP_DRUPAL_BUILD_DIR}/${DRUPAL_SITE_ID} ${DRUSH_MAKE_TMPROOT}/profiles/ && \
  mkdir -p ${DRUSH_MAKE_TMPROOT}/sites/all && \
  mv ${TMP_DRUPAL_BUILD_DIR}/settings ${DRUSH_MAKE_TMPROOT}/sites/all/ && \
  rm -rf ~/.drush/*

COPY scripts /scripts
COPY scripts/drupalCron.sh /etc/periodic/15min/drupalCron
