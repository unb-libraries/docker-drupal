#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ] && nslookup mailhog &> /dev/null; then
  # Enable local mail forwarding.
  sed -i 's/smtp\.unb\.ca/\[mailhog\]:1025/' /etc/postfix/main.cf
  postfix start
fi
