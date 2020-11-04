#!/usr/bin/env sh
if [ "$NR_INSTALL_KEY" != "" ]; then
  echo "Starting fluent-bit..."
  sed -i "s|NR_INSTALL_KEY|${NR_INSTALL_KEY}|g" /etc/fluent-bit/fluent-bit.conf
  sed -i "s|NGINX_LOG_FILE|${NGINX_LOG_FILE}|g" /etc/fluent-bit/fluent-bit.conf

  touch "$NGINX_LOG_FILE"
  touch "$NGINX_ERROR_LOG_FILE"

  /usr/bin/fluent-bit -c /etc/fluent-bit/fluent-bit.conf
fi
