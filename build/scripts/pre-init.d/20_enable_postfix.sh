#!/usr/bin/env sh
if [ "$DEPLOY_ENV" != "local" ]; then
  postfix start
fi
