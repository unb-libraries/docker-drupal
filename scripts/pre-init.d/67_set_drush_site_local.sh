#!/usr/bin/env sh
# Update the copy of global drush to use the site-local.
rm /usr/bin/drush
ln -s /app/html/vendor/bin/drush /usr/bin/drush
