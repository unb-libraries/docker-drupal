FROM unblibraries/drupal:8.x-2.x-slim
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV RSYNC_FLAGS --quiet

COPY ./build /build
RUN ${RSYNC_MOVE} /build/scripts/ /scripts/
