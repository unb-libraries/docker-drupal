FROM unblibraries/nginx-php:alpine-php7
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

LABEL ca.unb.lib.generator="drupal8" \
      com.microscaling.docker.dockerfile=/Dockerfile \
      com.microscaling.license=MIT \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vcs-ref="8.x-1.x" \
      org.label-schema.vcs-url="https://github.com/unb-libraries/docker-drupal" \
      org.label-schema.vendor="University of New Brunswick Libraries"

ENV COMPOSER_INSTALL "composer install --no-suggest --prefer-dist --no-interaction --no-progress"
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
ENV DRUPAL_CHOWN_PUBLIC_FILES_STARTUP TRUE
ENV DRUPAL_UNIT_TEST_MODULES ''
ENV DRUSH "doas -u ${NGINX_RUN_USER} -- /app/html/vendor/bin/drush --root=${DRUPAL_ROOT} --uri=default --yes"
ENV DRUSH_PHP /usr/bin/php

ENV RSYNC_FLAGS --quiet
ENV RSYNC_COPY "rsync -a --inplace --no-compress ${RSYNC_FLAGS}"
ENV RSYNC_MOVE "${RSYNC_COPY} --remove-source-files"

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
    redis \
    rsync \
    sudo \
    unzip && \
  /scripts/setupDoasConf.sh && \
  composer global require hirak/prestissimo zaporylie/composer-drupal-optimizations:^1.1 --prefer-dist --no-interaction --update-no-dev && rm -rf ~/.composer/cache && \
  cp /scripts/drupalCron.sh /etc/periodic/15min/drupalCron

# Volumes
VOLUME /app/html/sites/default
