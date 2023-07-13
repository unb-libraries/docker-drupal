#!/usr/bin/env sh

# Update config values.
sed -i "s|APP_HOSTNAME|$APP_HOSTNAME|g" /etc/postfix/main.cf

# Use Mailhog for Local Development
if [ "$DEPLOY_ENV" = "local" ]; then
  echo "Configuring postfix to use mailhog..."
  sed -i "s/relayhost = .*/relayhost = mailhog:1025/g" /etc/postfix/main.cf
fi

postfix start
