FROM unblibraries/drupal:8.x-2.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV ADDITIONAL_OS_PACKAGES php7-redis
ENV RSYNC_FLAGS --quiet

RUN apk --no-cache add redis

COPY scripts/ /scripts/
