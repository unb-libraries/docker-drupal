#!/usr/bin/env sh
# Shared validation functions for environment variables.

# Validate that an environment variable is set and non-empty.
# Usage: require_env VAR_NAME "Human readable description"
require_env() {
  VAR_NAME="$1"
  DESCRIPTION="${2:-$VAR_NAME}"
  eval "VAR_VALUE=\"\$$VAR_NAME\""
  if [ -z "$VAR_VALUE" ]; then
    echo "ERROR: $DESCRIPTION has not been set in \$$VAR_NAME"
    exit 1
  fi
}

# Validate that an environment variable is defined (can be empty string).
# Usage: require_env_defined VAR_NAME "Human readable description"
require_env_defined() {
  VAR_NAME="$1"
  DESCRIPTION="${2:-$VAR_NAME}"
  eval "test -z \"\${$VAR_NAME+x}\"" && {
    echo "ERROR: $DESCRIPTION variable \$$VAR_NAME is not defined"
    exit 1
  }
}
