FROM unblibraries/nginx-php:alpine-php7
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

LABEL ca.unb.lib.generator="drupal8" \
      com.microscaling.docker.dockerfile=/Dockerfile \
      com.microscaling.license=MIT \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vcs-ref="8.x-1.x" \
      org.label-schema.vcs-url="https://github.com/unb-libraries/docker-drupal" \
      org.label-schema.vendor="University of New Brunswick Libraries"

ARG DRUPAL_COMPOSER_DEV=no-dev

ENV DRUPAL_ADMIN_ACCOUNT_NAME admin
ENV DRUPAL_CONFIGURATION_DIR ${APP_ROOT}/configuration
ENV DRUPAL_CONFIGURATION_EXPORT_SKIP devel
ENV DRUPAL_DEPLOY_CONFIGURATION FALSE
ENV DRUPAL_ROOT $APP_WEBROOT
ENV DRUPAL_RUN_CRON TRUE
ENV DRUPAL_SITE_ID defaultd
ENV DRUPAL_SITE_UUID FALSE
ENV DRUPAL_TESTING_ROOT ${APP_ROOT}/tests
ENV DRUPAL_TESTING_TOOLS FALSE
ENV DRUPAL_UNIT_TEST_MODULES ''
ENV DRUSH "doas -u ${NGINX_RUN_USER} -- /app/html/vendor/bin/drush --root=${DRUPAL_ROOT} --uri=default --yes"
ENV DRUSH_PHP /usr/bin/php

ENV RSYNC_FLAGS --quiet
ENV TERM dumb

# Install required packages, libraries.
COPY ./scripts /scripts
RUN apk --no-cache add \
  doas \
  git \
  mysql-client \
  php7-ctype \
  php7-dom \
  php7-dom \
  php7-fileinfo \
  php7-gd \
  php7-mbstring \
  php7-mysqlnd \
  php7-opcache \
  php7-pcntl \
  php7-pdo \
  php7-pdo_mysql \
  php7-posix \
  php7-session \
  php7-simplexml \
  php7-tokenizer \
  php7-xml \
  php7-xmlwriter \
  rsync \
  sudo \
  unzip

# Add package conf, create build location.
COPY ./conf /conf
RUN cp /conf/nginx/app.conf /etc/nginx/conf.d/app.conf && \
  cp /conf/php/app-php.ini /etc/php7/conf.d/zz_app.ini && \
  cp /conf/php/app-php-fpm.conf /etc/php7/php-fpm.d/zz_app.conf && \
  rm -rf /conf && \
  /scripts/setupDoasConf.sh

# Build tree.
COPY ./build /build
RUN /scripts/buildDrupalTree.sh ${DRUPAL_COMPOSER_DEV} && \
  /scripts/installDevTools.sh ${DRUPAL_COMPOSER_DEV} && \
  cp /scripts/drupalCron.sh /etc/periodic/15min/drupalCron

# Tests.
COPY ./tests ${DRUPAL_TESTING_ROOT}
RUN /scripts/installTestingTools.sh ${DRUPAL_COMPOSER_DEV}

# Volumes
VOLUME /app/html/sites/default
