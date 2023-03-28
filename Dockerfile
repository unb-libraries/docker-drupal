FROM ghcr.io/unb-libraries/drupal:9.x-2.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

COPY ./build /build
RUN $RSYNC_MOVE /build/scripts/ /scripts/&& \
  /scripts/linkDrupalCronEntryInitUnb.sh

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref="9.x-2.x-unblib" \
  org.label-schema.version=$VERSION
