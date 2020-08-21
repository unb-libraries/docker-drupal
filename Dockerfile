FROM unblibraries/drupal:8.x-2.x-slim
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV DEPLOY_ENV prod
ENV DRUPAL_BASE_PROFILE minimal
ENV RSYNC_FLAGS --quiet

COPY ./build /build
COPY scripts/ /scripts/
