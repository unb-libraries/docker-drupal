#!/usr/bin/env sh
# Generate content to test persistence in a restart.
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default en --yes --pm-force devel_generate
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default --yes genc 5 --types=article
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default pm-uninstall --yes --pm-force devel_generate
