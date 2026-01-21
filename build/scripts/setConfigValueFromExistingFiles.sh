#!/usr/bin/env sh
SET_CONF_ENTITY=$1
SET_CONF_KEY=$2

if [ -z "$SET_CONF_ENTITY" ]
then
  echo "Conf entity not provided!"
  exit 1
fi

if [ -z "$SET_CONF_KEY" ]
then
  echo "Conf key not provided!"
  exit 1
fi

ENTITY_CONF_FILE="${DRUPAL_CONFIGURATION_DIR}/${SET_CONF_ENTITY}.yml"

if [ -f "$ENTITY_CONF_FILE" ]; then
  CURRENT_KEY_VALUE=$(yq eval ".$SET_CONF_KEY" "$ENTITY_CONF_FILE" 2>/dev/null)
  # yq returns "null" for missing keys
  [ "$CURRENT_KEY_VALUE" = "null" ] && CURRENT_KEY_VALUE=""
  if [ -n "$CURRENT_KEY_VALUE" ]; then
    echo "Setting ${SET_CONF_ENTITY}:${SET_CONF_KEY} to ${CURRENT_KEY_VALUE}"
    CUR_CONFIG_VALUE=$($DRUSH cget --format=list "$SET_CONF_ENTITY" "$SET_CONF_KEY")
    if [ ! "$CUR_CONFIG_VALUE" = "$CURRENT_KEY_VALUE" ]; then
      ${DRUSH} config-set "$SET_CONF_ENTITY" "$SET_CONF_KEY" "$CURRENT_KEY_VALUE"
    else
      echo "Skipping $SET_CONF_ENTITY $SET_CONF_KEY update due to identical stored value"
    fi
  fi
fi
