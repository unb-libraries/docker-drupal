#!/usr/bin/env sh
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default en --yes devel
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default --yes genc 5 --types=article
