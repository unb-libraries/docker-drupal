#!/usr/bin/env sh
# Add environment based container YAML to instance.

# Defaults.
DEFAULT_SERVICES_FILE="${DRUPAL_BUILD_TMPROOT}/sites/default/default.services.yml"
OUTPUT_SERVICES_FILE="${DRUPAL_BUILD_TMPROOT}/sites/default/services.yml"
OVERRIDE_SERVICES_PATH="${TMP_DRUPAL_BUILD_DIR}/services"
FILES_TO_COMBINE="$DEFAULT_SERVICES_FILE"
NEEDS_COMBINE="FALSE"

# Global overrides.
GLOBAL_SERVICES_YML="${OVERRIDE_SERVICES_PATH}/services.yml"
if [[ -f "${GLOBAL_SERVICES_YML}" ]]; then
  FILES_TO_COMBINE="$FILES_TO_COMBINE $GLOBAL_SERVICES_YML"
  NEEDS_COMBINE="TRUE"
fi

# Environment-specific services.
ENV_SERVICES_YML="${OVERRIDE_SERVICES_PATH}/services.${DEPLOY_ENV}.yml"
if [[ -f "${ENV_SERVICES_YML}" ]]; then
  FILES_TO_COMBINE="$FILES_TO_COMBINE $ENV_SERVICES_YML"
  NEEDS_COMBINE="TRUE"
fi

# Write final output.
if [[ "$NEEDS_COMBINE" == "TRUE" ]]; then
  echo "Combining overrides of services YML files..."
  COMBINE_COMMAND="/usr/bin/yq m -x ${FILES_TO_COMBINE}"
  echo "Executing [$COMBINE_COMMAND]"
  ${COMBINE_COMMAND} > ${OUTPUT_SERVICES_FILE}
else
  echo "Using default services YML files..."
fi
