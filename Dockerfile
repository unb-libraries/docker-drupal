FROM ghcr.io/unb-libraries/drupal:11.x-1.x

ENV DRUPAL_REDIS_HOSTNAME=drupal-redis-lib-unb-ca
ENV ENABLE_NEWRELIC=false
ENV ENABLE_NEWRELIC_TRACING=false

COPY ./build /build
RUN $RSYNC_MOVE /build/scripts/ /scripts/&& \
  /scripts/linkDrupalCronEntryInitUnb.sh && \
  mkdir -p /app/php && \
  cp /build/php-src/ContainerStderrLogger.php \
     /build/php-src/services.yml \
     /build/php-src/global.settings.php \
     /app/php/

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref="11.x-1.x-unblib" \
  org.label-schema.version=$VERSION
