#!/usr/bin/env sh
if [ -n "$DRUPAL_SITE_ID" ]; then
  redis-cli -h "$DRUPAL_REDIS_HOSTNAME" EVAL "for _,k in ipairs(redis.call('keys', ARGV[1])) do redis.call('del',k) end" 0 "$DRUPAL_SITE_ID:*:*"
fi
