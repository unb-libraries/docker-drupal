#!/bin/bash
set -euo pipefail

function testIslandoraRootObject() {
	curl -I --fail http://127.0.0.1/user
	return $?
}

retry=0
maxRetries=5
retryInterval=60
until [ ${retry} -ge ${maxRetries} ]
do
	testIslandoraRootObject && break
	retry=$[${retry}+1]
	echo "Retrying [${retry}/${maxRetries}] in ${retryInterval}(s) "
	sleep ${retryInterval}
done

if [ ${retry} -ge ${maxRetries} ]; then
  echo "Failed after ${maxRetries} attempts!"
  exit 1
fi
