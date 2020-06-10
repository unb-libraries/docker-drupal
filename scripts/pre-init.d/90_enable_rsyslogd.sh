#!/usr/bin/env sh
if [ "$LOGZIO_KEY" != "" ]; then
  echo "Starting rsyslogd..."

  # Remove unsupported mod.
  sed -i '/ModLoad imklog.so/d' /etc/rsyslog.conf

  # Add auth key.
  sed -i "s|LOGZIO_KEY|$LOGZIO_KEY|g" /etc/rsyslog.d/21-logzio-nginx.conf

  # Inject environmental details.
  sed -i "s|DEPLOY_ENV|$DEPLOY_ENV|g" /etc/rsyslog.d/21-logzio-nginx.conf
  sed -i "s|DEPLOY_URI|$DRUPAL_SITE_URI|g" /etc/rsyslog.d/21-logzio-nginx.conf

  # Start rsyslogd.
  /usr/sbin/rsyslogd -f /etc/rsyslog.conf
fi
