#!/usr/bin/env sh
# Add environment based container YAML to instance.

# Defaults.
DEFAULT_SERVICES_FILE="${DRUPAL_BUILD_TMPROOT}/sites/default/default.services.yml"
OUTPUT_SERVICES_FILE="${DRUPAL_BUILD_TMPROOT}/sites/default/services.yml"
OVERRIDE_SERVICES_PATH="${TMP_DRUPAL_BUILD_DIR}/services"

ls $OVERRIDE_SERVICES_PATH

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
if [[ -f "${ENV_SERVICES_YMLL}" ]]; then
  FILES_TO_COMBINE="$FILES_TO_COMBINE $ENV_SERVICES_YML"
  NEEDS_COMBINE="TRUE"
fi

# Write final output.
if [[ "$NEEDS_COMBINE" == "TRUE" ]]; then
  echo "Combining overrides of services YML files..."
  curl -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 -o /usr/bin/yq; chmod +x /usr/bin/yq
  /usr/bin/yq m -x ${FILES_TO_COMBINE} > "${OUTPUT_SERVICES_FILE}"
  rm -rf /usr/bin/yq
else
  echo "Using default services YML files..."
fi
