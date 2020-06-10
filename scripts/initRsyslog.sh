#!/usr/bin/env sh
mkdir -p /var/spool/rsyslog
touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
mkdir -p /var/spool/rsyslog
chgrp adm /var/spool/rsyslog
chmod g+w /var/spool/rsyslog

# Do not try to enable imklog module in unprivileged environment.
sed -i '/^module(load="imklog")$/s/^/#/' /etc/rsyslog.conf
