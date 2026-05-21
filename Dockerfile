FROM ghcr.io/unb-libraries/nginx-php:3.23.x

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV DRUPAL_ADMIN_ACCOUNT_NAME=admin
ENV DRUPAL_CONFIGURATION_DIR=$APP_ROOT/configuration
ENV DRUPAL_ROOT=$APP_WEBROOT
ENV DRUPAL_SITE_ID=
ENV DRUPAL_DB_NAME=
ENV DRUPAL_DB_USER=
ENV DRUPAL_DB_PASSWORD=
ENV DRUPAL_DB_HOSTNAME=
ENV DRUPAL_DB_PORT=
ENV DRUPAL_DB_DRIVER=mysql
ENV DRUPAL_DB_PREFIX=
ENV DRUPAL_SITE_UUID=FALSE
ENV DRUPAL_TESTING_ROOT=$APP_ROOT/tests
ENV DRUPAL_CHOWN_PUBLIC_FILES_STARTUP=FALSE
ENV DRUPAL_UNIT_TEST_MODULES=''
ENV DRUSH="doas -u $NGINX_RUN_USER -- /app/html/vendor/bin/drush --root=$DRUPAL_ROOT --uri=default --yes"
ENV DRUSH_PHP=/usr/bin/php

# Install required packages, libraries.
COPY ./build /build
RUN apk --no-cache add \
    doas \
    mysql-client \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-pcntl \
    php${PHP_VERSION}-pecl-uploadprogress \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-posix \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xmlwriter \
    redis \
    yq && \
  $RSYNC_MOVE /build/scripts/ /scripts/ && \
  $RSYNC_MOVE /build/data/htaccess/ /security_htaccess && \
  /scripts/setupDoasConf.sh && \
  /scripts/linkDrupalCronEntryInit.sh && \
  rm -rf ~/.composer/cache
WORKDIR /app/html

# Volumes
VOLUME /app/html/sites/default

LABEL ca.unb.lib.generator="drupal11" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.description="docker-drupal is the base drupal image at UNB Libraries." \
  org.label-schema.name="drupal" \
  org.label-schema.url="https://github.com/unb-libraries/docker-drupal" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/unb-libraries/docker-drupal" \
  org.label-schema.version=$VERSION \
  org.opencontainers.image.authors="UNB Libraries <libsupport@unb.ca>" \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-drupal"
