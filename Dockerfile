FROM unblibraries/drupal:8.x-3.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV RSYNC_FLAGS --quiet

COPY ./build /build
RUN ${RSYNC_MOVE} /build/scripts/ /scripts/

RUN apk --no-cache add fluent-bit --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
  mkdir -p /newrelic-fluent-bit && \
  wget https://github.com/newrelic/newrelic-fluent-bit-output/releases/download/1.4.3/out_newrelic.so && \
  mv out_newrelic.so /newrelic-fluent-bit/ && \
  cp /build/fluent/plugins.conf /etc/fluent-bit/plugins.conf && \
  cat /build/fluent/fluent-bit.conf >> /etc/fluent-bit/fluent-bit.conf
