#!/usr/bin/env sh
set -e

mkdir -p /tmp/blackfire
curl -A "Docker" -L https://blackfire.io/api/v1/releases/client/linux_static/amd64 | tar zxp -C /tmp/blackfire
mv /tmp/blackfire/blackfire /usr/bin/blackfire
rm -Rf /tmp/blackfire
