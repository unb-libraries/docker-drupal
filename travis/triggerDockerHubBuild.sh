#!/usr/bin/env bash
# Trigger an image's build on dockerhub. DOCKER_HUB_TRIGGER_TOKEN must be set
# in the Repository's "Environment Variables" on travis-ci.org.
DOCKERHUB_POST_DATA="{\"docker_tag\": \"${DOCKER_IMAGE_TAG}\"}"
curl -H "Content-Type: application/json" --data "${DOCKERHUB_POST_DATA}" -X POST "${DOCKER_HUB_TRIGGER_URL}"
