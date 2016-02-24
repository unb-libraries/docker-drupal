#!/usr/bin/env bash
set -euo pipefail

function testDrupalUserPage() {
  curl -I --fail http://127.0.0.1/user
  return $?
}

retry=0
maxRetries=5
retryInterval=60
until [ ${retry} -ge ${maxRetries} ]
do
  testDrupalUserPage && break
  retry=$[${retry}+1]
  echo "Drupal has not deployed. Waiting [${retry}/${maxRetries}] in ${retryInterval}(s) "
  sleep ${retryInterval}
done

if [ ${retry} -ge ${maxRetries} ]; then
  echo "Connecting to Drupal failed after ${maxRetries} attempts!"
  exit 1
fi
