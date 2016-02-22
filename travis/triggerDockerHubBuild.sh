#!/usr/bin/env bash
curl -H "Content-Type: application/json" --data '{"docker_tag": "alpine-nginx-8.x"}' -X POST https://registry.hub.docker.com/u/unblibraries/drupal/trigger/${DOCKER_HUB_TRIGGER_TOKEN}/
