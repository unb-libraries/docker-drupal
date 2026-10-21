# Rebuild Alpine's php82 at the upstream security release until Alpine ships it.
# CVE-2026-109618 / CVE-2026-109619: https://www.php.net/archive/2026.php#2026-10-21-5
# Remove this stage and build/php-apk once v3.22 community has php82 >= 8.2.35.
FROM alpine:3.22 AS php-apk
ENV PACKAGER="UNB Libraries <libsupport@unb.ca>"
RUN apk add alpine-sdk && \
  adduser -D builder && \
  addgroup builder abuild
COPY --chown=builder ./build/php-apk /home/builder/php-apk
USER builder
RUN abuild-keygen -an
USER root
RUN cp /home/builder/.abuild/*.rsa.pub /etc/apk/keys/
USER builder
WORKDIR /home/builder/php-apk/php82
RUN abuild -r

FROM ghcr.io/unb-libraries/drupal:9.x-4.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

# Serve the rebuilt packages as a local repository so later php82-* installs
# (site ADDITIONAL_OS_PACKAGES) resolve to the same build.
COPY --from=php-apk /home/builder/packages/php-apk /opt/php-apk
COPY --from=php-apk /home/builder/.abuild/*.rsa.pub /etc/apk/keys/
RUN echo "/opt/php-apk" >> /etc/apk/repositories && \
  apk add --no-cache --upgrade $(apk info | grep '^php82')

COPY ./build /build
RUN $RSYNC_MOVE /build/scripts/ /scripts/&& \
  rm -rf /build/php-apk && \
  /scripts/linkDrupalCronEntryInitUnb.sh

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref="9.x-4.x-unblib" \
  org.label-schema.version=$VERSION
