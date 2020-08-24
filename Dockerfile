FROM unblibraries/drupal:8.x-3.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV RSYNC_FLAGS --quiet

COPY ./build /build
RUN ${RSYNC_MOVE} /build/scripts/ /scripts/
