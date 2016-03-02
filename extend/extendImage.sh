#!/usr/bin/env bash
if [ ! -f extendImage.sh ]; then echo 'Please run this from the extend/ directory.'; exit 1; fi

# READ INPUT
random_slug=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 8)
read -rp "Enter an 8 Character (or less) Site Slug [default=$random_slug]: " site_slug
site_slug=${site_slug:-$random_slug}

default_deploy_dir="$HOME/docker-drupal-$site_slug"
read -rp "Enter a Deploy Dir [default=$default_deploy_dir]): " deploy_dir
deploy_dir=${deploy_dir:-$default_deploy_dir}
deploy_basename=$(basename $deploy_dir)

# USER INFO
user_name=$(git config --global user.name)
user_email=$(git config --global user.name)
user_string="$user_name \<$user_email\>"

# CHECK OPTIONS
if [ -d "$deploy_dir" ]; then
  echo "Directory $deploy_dir already exists. Cowardly refusing to do anything."
  exit 1
fi

mkdir -p "$deploy_dir"
if [ $? -ne 0 ] ; then
  echo "Creating directory $deploy_dir failed."
  exit 1
fi

# DEPLOY FILES
cp -rf ./* "$deploy_dir/"
rm -rf "$deploy_dir/extendImage.sh" "$deploy_dir/scripts"
mv "$deploy_dir/docker-drupal-SITESLUG" "$deploy_dir/docker-drupal-$site_slug"
cp -r ../build "$deploy_dir/docker-drupal-$site_slug/"
cp -r ../conf "$deploy_dir/docker-drupal-$site_slug/"
cp -r ./scripts "$deploy_dir/docker-drupal-$site_slug/"
mv "$deploy_dir/docker-drupal-$site_slug/scripts/pre-init.d/74_enable_EXTEND_SITESLUG_features.sh" "$deploy_dir/docker-drupal-$site_slug/scripts/pre-init.d/74_enable_${site_slug}_features.sh"

# FIND-REPLACE-STRINGS
find "$deploy_dir" -type f
find "$deploy_dir" -type f -print0 | xargs sed -i -e "s|EXTEND_USER_STRING|$user_string|g"
find "$deploy_dir" -type f -print0 | xargs sed -i -e "s|EXTEND_SITESLUG|$site_slug|g"
find "$deploy_dir" -type f -print0 | xargs sed -i -e "s|EXTEND_DEPLOY_BASENAME|$deploy_basename|g"
find "$deploy_dir" -type f -print0 | xargs sed -i -e "s|EXTEND_DEPLOY_DIR|$deploy_dir|g"
