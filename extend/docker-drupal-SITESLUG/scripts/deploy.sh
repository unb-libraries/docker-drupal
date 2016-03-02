#!/usr/bin/env bash
docker pull unblibraries/drupal:alpine-nginx-7.x
docker-compose stop
docker-compose kill
docker-compose rm -f
sudo rm -rf ./data
mkdir data
sudo chown -R 100:101 data
docker-compose build
docker-compose up -d; docker-compose logs
