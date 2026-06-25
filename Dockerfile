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

# Expose the downstream site's build id to the runtime so pre-init.d can stamp
# $settings['deployment_identifier'] (service-container / APCu / Twig cache key).
# ONBUILD defers to the *site* build, where dockworker passes VERSION as a build-arg
# (<short-sha>-<timestamp>). Unset on a bare image => the pre-init step no-ops.
ONBUILD ARG VERSION
ONBUILD ENV DRUPAL_DEPLOYMENT_IDENTIFIER=${VERSION}
