#!/usr/bin/env sh
df -Pk . | sed 1d | grep -v used | awk '{ print $4 "\t" }'

