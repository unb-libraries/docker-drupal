#!/usr/bin/env sh
CACHE_PREFIX=$(drush eval 'echo \Drupal\Core\Site\Settings::get("cache_prefix")["default"]')
if [ -n "$CACHE_PREFIX" ]; then
  redis-cli -h drupal-redis-lib-unb-ca EVAL "for _,k in ipairs(redis.call('keys', ARGV[1])) do redis.call('del',k) end" 0 "$CACHE_PREFIX:*:*"
fi


