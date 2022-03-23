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
    php8-ctype \
    php8-dom \
    php8-fileinfo \
    php8-mbstring \
    php8-mysqlnd \
    php8-opcache \
    php8-pcntl \
    php8-pecl-uploadprogress \
    php8-pdo \
    php8-pdo_mysql \
    php8-posix \
    php8-session \
    php8-simplexml \
    php8-tokenizer \
    php8-xmlwriter \
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
