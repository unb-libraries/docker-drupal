#!/usr/bin/env sh
df -P -B1 . | sed 1d | grep -v used | awk '{ print $4 "\t" }'

