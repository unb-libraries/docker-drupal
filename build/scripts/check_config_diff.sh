#!/usr/bin/env sh
DIFF_OUTPUT=$($DRUSH config:status)
if echo "$DIFF_OUTPUT" | grep -q "No differences"; then
  exit 0
else
  echo "$DIFF_OUTPUT"
  exit 1
fi
