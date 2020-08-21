#!/usr/bin/env sh
ADMIN_HASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
ADMIN_USERNAME="admin_${ADMIN_HASH}"
ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

# Avoid listing these values in logs.
echo 'Scrambling admin credentials...'
cd "$DRUPAL_ROOT"
${DRUSH} sql-query "UPDATE users_field_data SET name='${ADMIN_USERNAME}' WHERE uid=1;"
${DRUSH} upwd "${ADMIN_USERNAME}" "${ADMIN_PASSWORD}"
