#!/usr/bin/env sh
docker exec dockerdrupal_drupal_1 drush --root=/app/html --uri=default en --yes simpletest
docker exec dockerdrupal_drupal_1 su nginx -s /bin/sh -c 'php /app/html/core/scripts/run-tests.sh --url http://127.0.0.1 --php /usr/bin/php --die-on-fail --class "\Drupal\user\Tests\UserLoginTest"'
docker exec dockerdrupal_drupal_1 su nginx -s /bin/sh -c 'php /app/html/core/scripts/run-tests.sh --url http://127.0.0.1 --php /usr/bin/php --die-on-fail --class "\Drupal\node\Tests\PageViewTest"'
docker exec dockerdrupal_drupal_1 su nginx -s /bin/sh -c 'php /app/html/core/scripts/run-tests.sh --url http://127.0.0.1 --php /usr/bin/php --die-on-fail --class "\Drupal\system\Tests\File\UrlRewritingTest"'
docker exec dockerdrupal_drupal_1 su nginx -s /bin/sh -c 'php /app/html/core/scripts/run-tests.sh --url http://127.0.0.1 --php /usr/bin/php --die-on-fail --class "\Drupal\file\Tests\FilePrivateTest"'
