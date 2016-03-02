FROM unblibraries/drupal:alpine-nginx-8.x
MAINTAINER EXTEND_USER_STRING

ENV DRUPAL_SITE_ID EXTEND_SITESLUG

# Add nginx and PHP conf.
COPY conf/nginx/app.conf /etc/nginx/conf.d/app.conf
COPY conf/php/php.ini /etc/php/php.ini
COPY conf/php/php-fpm.conf /etc/php/php-fpm.conf

# Deploy the default makefile and install profile to the container
RUN rm -rf ${TMP_DRUPAL_BUILD_DIR}
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
