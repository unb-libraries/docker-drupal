#!/usr/bin/env sh
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default en --yes devel_generate
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default --yes genc 5 --types=article
