#!/usr/bin/env sh
# Iterate over
for ID in `postqueue -p | grep -v ^- | grep -v "(" | cut -d' ' -f1 | grep -e [[:alnum:]]`; do
  postqueue -i $ID
  sleep 2
done
