FROM ghcr.io/unb-libraries/drupal:10.x-1.x

ENV DRUPAL_REDIS_HOSTNAME=drupal-redis-lib-unb-ca
ENV ENABLE_NEWRELIC=false
ENV ENABLE_NEWRELIC_TRACING=false

COPY ./build /build
RUN $RSYNC_MOVE /build/scripts/ /scripts/&& \
  /scripts/linkDrupalCronEntryInitUnb.sh

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref="10.x-1.x-unblib" \
  org.label-schema.version=$VERSION
