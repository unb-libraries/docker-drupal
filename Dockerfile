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
ENV DRUPAL_INSTALL_REMOVE_SHORTCUT TRUE
ENV DRUPAL_REBUILD_ON_REDEPLOY TRUE
ENV DRUPAL_REVERT_FEATURES FALSE
ENV DRUPAL_ROOT $APP_WEBROOT
ENV DRUPAL_SITE_ID defaultd
ENV DRUPAL_SITE_UUID FALSE
ENV DRUPAL_TESTING_ROOT ${APP_ROOT}/tests
ENV DRUPAL_TESTING_TOOLS FALSE
ENV DRUPAL_UNIT_TEST_MODULES ''
ENV DRUSH "sudo -u ${NGINX_RUN_USER} -g ${NGINX_RUN_GROUP} -E -- /app/html/vendor/bin/drush --root=${DRUPAL_ROOT} --uri=default --yes"
ENV DRUSH_PHP /usr/bin/php

ENV RSYNC_FLAGS --quiet
ENV TERM dumb
ENV TMP_DRUPAL_BUILD_DIR /tmp/drupal_build
ENV DRUPAL_BUILD_TMPROOT ${TMP_DRUPAL_BUILD_DIR}/webroot

# Install required packages, libraries.
RUN apk --no-cache add php7-mysqlnd php7-session php7-pdo php7-pdo_mysql \
  php7-pcntl php7-dom php7-posix php7-ctype php7-gd php7-xml php7-opcache \
  php7-mbstring php7-tokenizer php7-simplexml php7-xmlwriter git unzip \
  php7-dom php7-fileinfo mysql-client rsync sudo

# Add package conf, create build location.
COPY ./conf /conf
RUN cp /conf/nginx/app.conf /etc/nginx/conf.d/app.conf && \
  cp /conf/php/app-php.ini /etc/php7/conf.d/zz_app.ini && \
  cp /conf/php/app-php-fpm.conf /etc/php7/php-fpm.d/zz_app.conf && \
  rm -rf /conf && \
  mkdir -p ${TMP_DRUPAL_BUILD_DIR}

# Build tree.
COPY ./scripts /scripts
COPY ./build/ ${TMP_DRUPAL_BUILD_DIR}
RUN /scripts/buildDrupalTree.sh ${DRUPAL_COMPOSER_DEV} && \
  /scripts/installDevTools.sh ${DRUPAL_COMPOSER_DEV} && \
  cp /scripts/drupalCron.sh /etc/periodic/15min/drupalCron

# Tests.
COPY ./tests ${DRUPAL_TESTING_ROOT}
RUN /scripts/installTestingTools.sh ${DRUPAL_COMPOSER_DEV}

# Volumes
VOLUME /app/html/sites/default
