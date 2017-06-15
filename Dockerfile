FROM unblibraries/nginx-php:alpine-php7
MAINTAINER Jacob Sanford <libsystems_at_unb.ca>

LABEL ca.unb.lib.generator="drupal8"
LABEL vcs-ref="alpine-nginx-php7-8.x"
LABEL vcs-url="https://github.com/unb-libraries/docker-drupal"

ARG DRUPAL_COMPOSER_DEV=no-dev

ENV DRUPAL_ADMIN_ACCOUNT_NAME admin
ENV DRUPAL_CONFIGURATION_DIR ${APP_ROOT}/configuration
ENV DRUPAL_CONFIGURATION_EXPORT_SKIP devel
ENV DRUPAL_DEPLOY_CONFIGURATION FALSE
ENV DRUPAL_REBUILD_ON_REDEPLOY TRUE
ENV DRUPAL_REVERT_FEATURES FALSE
ENV DRUPAL_ROOT $APP_WEBROOT
ENV DRUPAL_SITE_ID defaultd
ENV DRUPAL_SITE_UUID FALSE
ENV DRUPAL_TESTING_TOOLS FALSE
ENV RSYNC_FLAGS --stats
ENV TERM dumb
ENV TMP_DRUPAL_BUILD_DIR /tmp/drupal_build

RUN apk --update add php7-mysqlnd php7-session php7-pdo php7-pdo_mysql \
  php7-pcntl php7-dom php7-posix php7-ctype php7-gd php7-xml php7-opcache \
  php7-mbstring php7-tokenizer php7-simplexml php7-xmlwriter git unzip \
  mysql-client rsync && \
  rm -f /var/cache/apk/*

# Add nginx and PHP conf.
COPY ./conf/nginx/app.conf /etc/nginx/conf.d/app.conf
COPY ./conf/php/app-php.ini /etc/php7/conf.d/zz_app.ini
COPY ./conf/php/app-php-fpm.conf /etc/php7/php-fpm.d/zz_app.conf

# Add the build and install profiles to the container
RUN mkdir -p ${TMP_DRUPAL_BUILD_DIR}
COPY ./build/ ${TMP_DRUPAL_BUILD_DIR}
COPY ./tests/behat.yml ${TMP_DRUPAL_BUILD_DIR}/behat.yml
COPY ./tests/features ${TMP_DRUPAL_BUILD_DIR}/features

# Copy scripts to container.
COPY ./scripts /scripts
COPY ./scripts/drupalCron.sh /etc/periodic/15min/drupalCron

# Build Drupal tree.
ENV DRUPAL_BUILD_TMPROOT ${TMP_DRUPAL_BUILD_DIR}/webroot
RUN /scripts/buildDrupalTree.sh ${DRUPAL_COMPOSER_DEV}
