#!/usr/bin/env bash
#
if [ ! -f extendImage.sh ]; then echo 'Please run this from the extend/ directory.'; exit 1; fi

cat docs/intro.txt

# READ INPUT
# Site Slug
cat docs/slug.txt
random_slug=$(env LC_CTYPE=C tr -dc "a-z0-9" < /dev/urandom | head -c 8)
read -rp "Enter an 8 Character (or less) Site Slug [default=$random_slug]: " site_slug
site_slug=${site_slug:-$random_slug}

forbidden_slug_values=("minimal" "standard" "testing" "drupal")
if [[ " ${forbidden_slug_values[@]} " =~ " ${site_slug} " ]]; then echo 'The Site Slug is a forbidden value!'; exit 1; fi

if [ ${#site_slug} -eq 0 ]; then echo 'The Site Slug is empty'; exit 1; fi
if [ ${#site_slug} -gt 8 ]; then echo 'The Site Slug is greater than 8 characters'; exit 1; fi
if [[ "$site_slug" =~ [^a-zA-Z0-9] ]]; then echo 'The Site Slug contains forbidden characters. Please use only [a-z0-9]. '; exit 1; fi

# Deploy Path
cat docs/path.txt
default_deploy_dir="$HOME/docker-drupal-$site_slug"
read -rp "Enter a Deploy Path [default=$default_deploy_dir]): " deploy_dir
deploy_dir=${deploy_dir:-$default_deploy_dir}
deploy_basename=$(basename $deploy_dir)
if [[ "$deploy_dir" =~ [^a-zA-Z0-9/_-] ]]; then echo 'The Path contains forbidden characters. Please use only [a-zA-Z0-9/_-]. '; exit 1; fi

# USER INFO
user_name=$(git config --global user.name)
user_email=$(git config --global user.email)
user_string="$user_name <$user_email>"

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

# Get Local User's Group
local_user_group=$(id -g)

# DEPLOY FILES
cp -rf ./* "$deploy_dir/"
rm -rf "$deploy_dir/extendImage.sh" "$deploy_dir/scripts"
mv "$deploy_dir/docker-drupal-SITESLUG" "$deploy_dir/docker-drupal-$site_slug"
cp -r ../build "$deploy_dir/docker-drupal-$site_slug/"
cp -r ../conf "$deploy_dir/docker-drupal-$site_slug/"
mv "$deploy_dir/docker-drupal-$site_slug/scripts/pre-init.d/74_enable_EXTEND_SITESLUG_features.sh" "$deploy_dir/docker-drupal-$site_slug/scripts/pre-init.d/74_enable_${site_slug}_features.sh"
mv "$deploy_dir/docker-drupal-$site_slug/scripts/deploy.sh" "$deploy_dir/"

# Alter Profile to Use site_slug
mv "$deploy_dir/docker-drupal-$site_slug/build/defaultd" "$deploy_dir/docker-drupal-$site_slug/build/$site_slug"
mv "$deploy_dir/docker-drupal-$site_slug/build/defaultd.yml" "$deploy_dir/docker-drupal-$site_slug/build/$site_slug.yml"
mv "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/defaultd.info.yml" "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/$site_slug.info.yml"
mv "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/defaultd.install" "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/$site_slug.install"
mv "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/defaultd.profile" "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/$site_slug.profile"
mv "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/defaultd.links.menu.yml" "$deploy_dir/docker-drupal-$site_slug/build/$site_slug/$site_slug.links.menu.yml"
find "$deploy_dir/docker-drupal-$site_slug/build/" -type f -print0 | xargs -0 sed -i '' -e "s|defaultd|$site_slug|g"

# FIND-REPLACE-STRINGS
find "$deploy_dir" -type f -print0 | xargs -0 sed -i '' -e "s|EXTEND_SITESLUG|$site_slug|g"
find "$deploy_dir" -type f -print0 | xargs -0 sed -i '' -e "s|EXTEND_USER_STRING|$user_string|g"
find "$deploy_dir" -type f -print0 | xargs -0 sed -i '' -e "s|EXTEND_DEPLOY_BASENAME|$deploy_basename|g"
find "$deploy_dir" -type f -print0 | xargs -0 sed -i '' -e "s|EXTEND_DEPLOY_DIR|$deploy_dir|g"
find "$deploy_dir" -type f -print0 | xargs -0 sed -i '' -e "s|EXTEND_LOCAL_GROUP|$local_user_group|g"

echo "Extension complete! cd $deploy_dir; ./deploy.sh"
