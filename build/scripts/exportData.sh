#!/usr/bin/env sh
set -e

# Initialize variables
NO_FILES=false
BASE_PATH='/data-export'

# Function to show usage
usage() {
    echo "Usage: $0 [EXPORT_PATH] [--no-files]"
    exit 1
}

# Check if first argument is missing or an option
if [ $# -eq 0 ] || [ "${1#--}" != "$1" ]; then
    echo "No target location specified, generating random location."
    HASH=$(echo $RANDOM | md5sum | head -c 20; echo)
    EXPORT_PATH="$BASE_PATH/$HASH"
    mkdir -p "$EXPORT_PATH"

    if [ -n "$NGINX_RUN_USER" ] && [ -n "$NGINX_RUN_GROUP" ]; then
        chown "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" "$EXPORT_PATH"
    else
        echo "Warning: NGINX_RUN_USER or NGINX_RUN_GROUP not set. Skipping chown."
    fi
else
    EXPORT_PATH="$1"
    shift  # Move to the next argument
fi

# Process optional arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --no-files)
            NO_FILES=true
            ;;
        *)
            echo "Error: Unknown option '$1'"
            usage
            ;;
    esac
    shift
done

# Export Content
/scripts/exportContent.sh "$EXPORT_PATH"

# Only export files if --no-files was NOT set
if [ "$NO_FILES" = false ]; then
    /scripts/exportFiles.sh "$EXPORT_PATH"
else
    echo "Skipping file export (--no-files was set)."
fi
