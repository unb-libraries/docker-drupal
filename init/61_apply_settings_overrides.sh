#!/usr/bin/env bash

# Apply settings overrides
OVERRIDE_SOURCE_FILE="${TMP_DRUPAL_BUILD_DIR}/settings_override.php"
OVERRIDE_TARGET_FILE="${DRUPAL_ROOT}/sites/default/settings.php"

if [ -e $OVERRIDE_SOURCE_FILE ]; then
while read -u 10 CONF_LINE; do
  TRIMMED_LINE=`echo "$CONF_LINE" | xargs -0`
  grep -q "^$TRIMMED_LINE\$" $OVERRIDE_TARGET_FILE || echo "$TRIMMED_LINE" >> $OVERRIDE_TARGET_FILE
done 10<$OVERRIDE_SOURCE_FILE
fi
