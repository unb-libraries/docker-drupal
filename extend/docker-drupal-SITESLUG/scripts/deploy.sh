#!/usr/bin/env bash

# Test run location
if [ ! -f docker-compose.yml ]; then echo 'Please run this from the root of your extension directory.'; exit 1; fi

# If a data directory exists, warn user how destructive this script is.
if [ -d ./data ]; then
  read -p "This will delete the database, persistent filesystem in ./data and build the container again from scratch. Are you sure? " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      echo "Exiting without any action."
      exit 0
  fi
fi

# Inject dev URI into container environment
if [ -n "$DOCKER_HOST" ]; then
  # User is using docker-machine. Get host via DOCKER_HOST.
  read docker_host_ip < <(echo "$DOCKER_HOST" | grep -o '[0-9]\+[.][0-9]\+[.][0-9]\+[.][0-9]\+')
  read docker_host_port < <(cat docker-compose.yml | grep ':80"'  | awk '{print $2}' | sed 's|"||g' | sed 's|:80||g')
  docker_web_uri="http://$docker_host_ip:$docker_host_port"
  dev_web_uri="DEV_WEB_URI=$docker_web_uri"
  sed -i '' -e '/DEV_WEB_URI/d' ./drupal.env
  echo "$dev_web_uri" >> drupal.env
fi

# Ensure we are extending the latest image.
docker pull unblibraries/drupal:alpine-nginx-7.x
docker pull mysql

# Stop, kill and remove any current containers.
docker-compose stop
docker-compose kill
docker-compose rm -f

# Remove data from persistent share
sudo rm -rf ./data

# Create persistent share, assign to Nginx UID
mkdir data
sudo chown -R 100:101 data

# Build drupal image
docker-compose build

# Launch container and output logs
docker-compose up -d
docker-compose logs
