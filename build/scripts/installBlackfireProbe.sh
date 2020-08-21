#!/usr/bin/env sh
set -e

version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")
curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version
mkdir -p /tmp/blackfire
tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire
mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so
printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /etc/php7/conf.d/blackfire.ini
rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
