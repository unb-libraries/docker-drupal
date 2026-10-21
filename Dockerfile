# Rebuild Alpine's php84 at the upstream security release until Alpine ships it.
# CVE-2026-109618 / CVE-2026-109619: https://www.php.net/archive/2026.php#2026-10-21-5
# Remove this stage and build/php-apk once v3.23 community has php84 >= 8.4.27.
FROM alpine:3.23 AS php-apk
ENV PACKAGER="UNB Libraries <libsupport@unb.ca>"
RUN apk add alpine-sdk && \
  adduser -D builder && \
  addgroup builder abuild
COPY --chown=builder ./build/php-apk /home/builder/php-apk
# abuild -r installs makedepends through setuid abuild-apk, which fails under
# QEMU for the arm64 build. Install them as root and build with -d instead.
RUN cd /home/builder/php-apk/php84 && \
  . ./APKBUILD && \
  apk add $(for d in $makedepends; do case "$d" in "$pkgname"*) ;; *) echo "$d" ;; esac; done)
USER builder
RUN abuild-keygen -an
USER root
RUN cp /home/builder/.abuild/*.rsa.pub /etc/apk/keys/
USER builder
WORKDIR /home/builder/php-apk/php84
RUN abuild -d

FROM ghcr.io/unb-libraries/drupal:11.x-1.x

ENV DRUPAL_REDIS_HOSTNAME=drupal-redis-lib-unb-ca
ENV ENABLE_NEWRELIC=false
ENV ENABLE_NEWRELIC_TRACING=false

# Serve the rebuilt packages as a local repository so later php84-* installs
# (site ADDITIONAL_OS_PACKAGES) resolve to the same build.
COPY --from=php-apk /home/builder/packages/php-apk /opt/php-apk
COPY --from=php-apk /home/builder/.abuild/*.rsa.pub /etc/apk/keys/
RUN echo "/opt/php-apk" >> /etc/apk/repositories && \
  apk add --no-cache --upgrade $(apk info | grep '^php84')

COPY ./build /build
RUN $RSYNC_MOVE /build/scripts/ /scripts/&& \
  rm -rf /build/php-apk && \
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
