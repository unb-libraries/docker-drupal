#!/usr/bin/env sh
if [ -n "$LOCAL_HOSTNAME" ] && [ -n "$LOCAL_PORT" ]; then
  printf "\nVisit your instance at:" > /tmp/startup_block.txt
  printf "\nhttp://$LOCAL_HOSTNAME:$LOCAL_PORT" >> /tmp/startup_block.txt

  printf "\n\nLog-in to your instance via:\n" >> /tmp/startup_block.txt
  /scripts/drupalUli.sh >> /tmp/startup_block.txt

  if nc -z mailhog 1025; then
    MAILHOG_PORT=$((LOCAL_PORT+1000))
    printf "\nView sent mail at:\n" >> /tmp/startup_block.txt
    echo "http://$LOCAL_HOSTNAME:$MAILHOG_PORT" >> /tmp/startup_block.txt
  fi
fi

cat /scripts/data/complete.txt
cat /tmp/startup_block.txt
printf "\n"
