FROM unblibraries/drupal:8.x-3.x
MAINTAINER UNB Libraries <libsupport@unb.ca>

ENV NGINX_LOG_FILE /proc/self/fd/1
ENV NGINX_ERROR_LOG_FILE /proc/self/fd/2
ENV PHP_FPM_ERROR_LOG /proc/self/fd/2
ENV RSYNC_FLAGS --quiet

COPY ./build /build
RUN ${RSYNC_MOVE} /build/scripts/ /scripts/
