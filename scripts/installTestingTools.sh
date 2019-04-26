#!/usr/bin/env sh
# Install composer libraries for testing tools.
for d in $DRUPAL_TESTING_ROOT/*; do
  if [[ -d "$d" ]]; then
  echo
    echo "Installing testing libraries in $d"
    cd $d
    composer install --no-suggest --prefer-dist --no-interaction
    cd ..
  fi
done
