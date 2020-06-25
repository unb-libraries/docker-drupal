FROM unblibraries/drupal:8.x-2.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV ADDITIONAL_OS_PACKAGES php7-redis
ENV DEPLOY_ENV prod
ENV DRUPAL_BASE_PROFILE minimal
ENV RSYNC_FLAGS --quiet

RUN apk --no-cache add redis && \
  rm -rf /build

COPY scripts/ /scripts/
