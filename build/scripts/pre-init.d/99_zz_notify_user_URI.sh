#!/usr/bin/env sh
if [ -n "$LOCAL_HOSTNAME" ] && [ -n "$LOCAL_PORT" ]; then
  printf "\nVisit your instance at:"
  printf "\nhttp://$LOCAL_HOSTNAME"

  printf "\n\nLog-in to your instance via:\n"
  /scripts/drupalUli.sh
  if nslookup mailhog &> /dev/null; then
    MAILHOG_PORT=$((LOCAL_PORT+1000))
    printf "\nView sent mail at:\n"
    echo "http://$LOCAL_HOSTNAME:$MAILHOG_PORT"
  fi
fi
