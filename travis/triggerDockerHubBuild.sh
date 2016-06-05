#!/usr/bin/env bash
# Trigger an image's build on dockerhub. DOCKER_HUB_TRIGGER_TOKEN must be set
# in the Repository's "Environment Variables" on travis-ci.org.
DOCKERHUB_POST_DATA="{\"docker_tag\": \"${DOCKER_IMAGE_TAG}\"}"
DOCKERHUB_POST_URI="https://registry.hub.docker.com/u/${DOCKER_IMAGE_NAME}/trigger/${DOCKER_HUB_TRIGGER_TOKEN}/"

curl -H "Content-Type: application/json" --data "${DOCKERHUB_POST_DATA}" -X POST "${DOCKERHUB_POST_URI}"
