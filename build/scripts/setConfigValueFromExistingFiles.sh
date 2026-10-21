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

# Reject inputs outside Drupal's allowed config-name charset. Defensive: the
# entity name is interpolated into a filesystem path and into drush args.
case "$SET_CONF_ENTITY" in
  *[!a-zA-Z0-9._-]*|"")
    echo "Invalid config entity name: '$SET_CONF_ENTITY'"
    exit 1
    ;;
esac
case "$SET_CONF_KEY" in
  *[!a-zA-Z0-9._-]*|"")
    echo "Invalid config key name: '$SET_CONF_KEY'"
    exit 1
    ;;
esac

ENTITY_CONF_FILE="${DRUPAL_CONFIGURATION_DIR}/${SET_CONF_ENTITY}.yml"

if [ -f "$ENTITY_CONF_FILE" ]; then
  TARGET_VALUE=$(yq eval ".$SET_CONF_KEY" "$ENTITY_CONF_FILE" 2>/dev/null)
  # yq returns the literal "null" for missing keys
  [ "$TARGET_VALUE" = "null" ] && TARGET_VALUE=""
  if [ -n "$TARGET_VALUE" ]; then
    # Read the full active record. We need to know it exists AND has data
    # before issuing config-set. drush config-set on a missing/empty record
    # creates a partial record containing only the one key we set, which
    # later breaks ConfigEntity imports (e.g. ConfigurableLanguage::save
    # throws "The entity does not have an ID."). Empty/missing is treated
    # identically: in either case, let deploy.d/74.40_import_configuration.sh
    # create or repair the record via the entity API.
    ACTIVE_YAML=$($DRUSH cget --format=yaml "$SET_CONF_ENTITY" 2>/dev/null)
    if [ -z "$ACTIVE_YAML" ]; then
      echo "Skipping ${SET_CONF_ENTITY}:${SET_CONF_KEY}: no active config to update (record missing/empty, or drush could not read it; config import will create or repair the record)"
      exit 0
    fi

    CURRENT_VALUE=$(printf '%s\n' "$ACTIVE_YAML" | yq eval ".$SET_CONF_KEY" - 2>/dev/null)
    [ "$CURRENT_VALUE" = "null" ] && CURRENT_VALUE=""

    if [ "$CURRENT_VALUE" != "$TARGET_VALUE" ]; then
      echo "Setting ${SET_CONF_ENTITY}:${SET_CONF_KEY} to ${TARGET_VALUE}"
      ${DRUSH} config-set "$SET_CONF_ENTITY" "$SET_CONF_KEY" "$TARGET_VALUE"
    else
      echo "Skipping ${SET_CONF_ENTITY}:${SET_CONF_KEY} update due to identical stored value"
    fi
  fi
fi
