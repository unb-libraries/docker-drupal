#!/usr/bin/env sh
DIFF_OUTPUT=$($DRUSH config:status 2>&1)
if echo "$DIFF_OUTPUT" | grep -q "No differences"; then
  echo "No differences between DB and sync directory"
  exit 0
else
  echo "$DIFF_OUTPUT"
  exit 1
fi
