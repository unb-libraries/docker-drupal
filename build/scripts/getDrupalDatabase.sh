#!/usr/bin/env sh
$DRUSH status | grep 'DB name' | awk '{print $4}' | tr -d '\n'
