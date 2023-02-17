FROM ghcr.io/unb-libraries/nginx-php:3.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV DRUPAL_ADMIN_ACCOUNT_NAME admin
ENV DRUPAL_CONFIGURATION_DIR $APP_ROOT/configuration
ENV DRUPAL_ROOT $APP_WEBROOT
ENV DRUPAL_SITE_ID defaultd
ENV DRUPAL_SITE_UUID FALSE
ENV DRUPAL_TESTING_ROOT $APP_ROOT/tests
ENV DRUPAL_CHOWN_PUBLIC_FILES_STARTUP FALSE
ENV DRUPAL_UNIT_TEST_MODULES ''
ENV DRUSH "doas -u $NGINX_RUN_USER -- /app/html/vendor/bin/drush --root=$DRUPAL_ROOT --uri=default --yes"
ENV DRUSH_PHP /usr/bin/php

# Install required packages, libraries.
COPY ./build /build
RUN apk --no-cache add \
    doas \
    mysql-client \
    php-ctype \
    php-dom \
    php-dom \
    php-fileinfo \
    php-intl \
    php-mbstring \
    php-mysqlnd \
    php-opcache \
    php-pcntl \
    php81-pecl-uploadprogress \
    php-pdo \
    php-pdo_mysql \
    php-posix \
    php-session \
    php-simplexml \
    php-tokenizer \
    php-xmlwriter \
    redis \
    yq && \
  $RSYNC_MOVE /build/scripts/ /scripts/ && \
  $RSYNC_MOVE /build/data/htaccess/ /security_htaccess && \
  /scripts/setupDoasConf.sh && \
  /scripts/linkDrupalCronEntryInit.sh && \
  rm -rf ~/.composer/cache

# Volumes
VOLUME /app/html/sites/default

LABEL ca.unb.lib.generator="drupal9" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.description="docker-drupal is the base drupal image at UNB Libraries." \
  org.label-schema.name="drupal" \
  org.label-schema.url="https://github.com/unb-libraries/docker-drupal" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/unb-libraries/docker-drupal" \
  org.label-schema.version=$VERSION \
  org.opencontainers.image.source="https://github.com/unb-libraries/docker-drupal"
