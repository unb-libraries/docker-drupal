#!/usr/bin/env sh
chgrp -R "${LOCAL_USER_GROUP}" "${DRUPAL_ROOT}"
chmod g+w -R "${DRUPAL_ROOT}"
