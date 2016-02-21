#!/bin/bash
curl -H "Content-Type: application/json" --data '{"source_type": "Branch", "source_name": "alpine-nginx-7.x"}' -X POST https://registry.hub.docker.com/u/unblibraries/drupal/trigger/${DOCKER_HUB_TRIGGER_TOKEN}/
