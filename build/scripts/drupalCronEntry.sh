#!/usr/bin/env sh
for i in /scripts/pre-init.cron.d/*sh
do
  if [ -e "${i}" ]; then
    SCRIPT_NAME=$(basename $i)
    START_TIME=$(date +%s)
    echo "[i] pre-init.d - $SCRIPT_NAME..."
    "${i}"
    FINISH_TIME=$(date +%s)
    STARTUP_TIME=`expr $FINISH_TIME - $START_TIME`
    echo "${SCRIPT_NAME}|${STARTUP_TIME}s" >> /tmp/deploy_time.txt
  fi
done
