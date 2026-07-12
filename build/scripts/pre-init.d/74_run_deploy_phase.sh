#!/usr/bin/env sh
# Once-per-deployment gate.
#
# The heavy, mutating deploy steps (updatedb, extension sync, hardcoded config, config
# import, cache rebuild) live in /scripts/deploy.d/. They are NOT auto-run by the base
# image's pre-init.d loop; this orchestrator is the only thing that runs them, and it
# runs them exactly once per deployment: it compares this image's build id
# (DRUPAL_DEPLOYMENT_IDENTIFIER, stamped by 62_set_deployment_identifier.sh) against the
# last id recorded as successfully deployed in the shared database. On an unchanged
# restart the entire phase is skipped, turning a multi-second/minute startup into a
# single SELECT.
#
# Single-execution across pods relies on the RollingUpdate maxSurge:1 strategy: k8s brings
# up one new pod at a time, so the first new pod deploys and later pods see the marker and
# skip. Genuinely concurrent deploys (Recreate / maxSurge>1 / a concurrent first install)
# run the steps unguarded on each pod -- exactly the behavior before this change. A future
# single-flight lease would wrap the "run" branch below.
#
# set -e: this script runs several commands, so it needs its own set -e to abort on the
# first failure (a single-command pre-init.d script can rely on run.sh's set -e, but a
# multi-step orchestrator cannot). A non-zero exit here aborts run.sh before `exec nginx`,
# crashing the container so k8s retries -- and, crucially, the marker is left unwritten so
# the retry re-runs the deploy.
set -e

. /scripts/lib/deploy_guard.sh

DEPLOY_D_DIR=/scripts/deploy.d

# Run every deploy.d step in numeric (glob) order.
run_deploy_steps() {
  for STEP in "$DEPLOY_D_DIR"/*sh; do
    [ -e "$STEP" ] || continue
    echo "[i] deploy.d - $(basename "$STEP")..."
    "$STEP"
  done
}

# Local development must always run every step on every boot; never gate.
if [ "$DEPLOY_ENV" = "local" ]; then
  echo "[i] Deploy phase: DEPLOY_ENV=local; running all deploy steps unconditionally."
  run_deploy_steps
  exit 0
fi

# No build identifier (bare/non-versioned image): preserve legacy always-run behavior.
if [ -z "$DRUPAL_DEPLOYMENT_IDENTIFIER" ]; then
  echo "[i] Deploy phase: DRUPAL_DEPLOYMENT_IDENTIFIER unset; running all deploy steps."
  run_deploy_steps
  exit 0
fi

CURRENT_ID=$(printf '%s' "$DRUPAL_DEPLOYMENT_IDENTIFIER" | tr -cd 'A-Za-z0-9._-')

deploy_guard_ensure_table
LAST_ID=$(deploy_guard_last_completed)

if [ "$LAST_ID" = "$CURRENT_ID" ]; then
  echo "[i] Deploy phase: build '$CURRENT_ID' already deployed; skipping deploy steps."
  exit 0
fi

echo "[i] Deploy phase: deploying build '$CURRENT_ID' (last deployed: '${LAST_ID:-none}')..."
run_deploy_steps
deploy_guard_mark_complete "$CURRENT_ID"
echo "[i] Deploy phase: build '$CURRENT_ID' recorded as deployed."
