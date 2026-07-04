<?php

/**
 * @file
 * Emits a snapshot manifest (snapshot.json) describing a completed export.
 *
 * Usage: php writeSnapshotManifest.php <export_path>
 *
 * The manifest is the snapshot's commit marker and must be written LAST, after
 * all artifacts and their checksums have been produced. It records provenance,
 * version info, a description, and per-artifact size + sha256. Artifact
 * checksums are read from the .sha256 sidecars produced during export (a single
 * pass), which are then removed so only the artifacts and manifest remain.
 *
 * Environment:
 *   SNAPSHOT_NAME         The snapshot name (default: nightly).
 *   SNAPSHOT_CREATED_BY   Provenance (default: cron; e.g. dockworker:<user>).
 *   SNAPSHOT_DESCRIPTION  Free-text description (default: empty).
 *   DEPLOY_ENV            The environment/namespace (prod, dev, ...).
 *   GIT_COMMIT/SOURCE_COMMIT  Optional build commit reference.
 *   DRUSH                 Optional drush invocation (for the Drupal version).
 */

$path = $argv[1] ?? '';
if ($path === '' || !is_dir($path)) {
    fwrite(STDERR, "Invalid or missing export path.\n");
    exit(1);
}

// Enumerate the known artifacts that are present, pairing each with the size
// and sha256 captured during export.
$artifacts = [];
foreach (['db.sql.gz', 'files.tar.gz'] as $file) {
    $full = "$path/$file";
    if (!file_exists($full)) {
        continue;
    }
    $sha = '';
    $sha_file = "$full.sha256";
    if (file_exists($sha_file)) {
        $sha = trim((string) file_get_contents($sha_file));
    }
    $artifacts[] = [
        'file' => $file,
        'bytes' => (int) filesize($full),
        'sha256' => $sha,
    ];
}

// Best-effort Drupal version; must never fail the snapshot.
$drupal_version = null;
$drush = getenv('DRUSH');
if (!is_string($drush) || $drush === '') {
    $drush = 'drush';
}
$version_output = @shell_exec($drush . ' status --field=drupal-version 2>/dev/null');
if (is_string($version_output) && trim($version_output) !== '') {
    $drupal_version = trim($version_output);
}

$git_commit = getenv('GIT_COMMIT');
if (!is_string($git_commit) || $git_commit === '') {
    $git_commit = getenv('SOURCE_COMMIT');
}
if (!is_string($git_commit) || $git_commit === '') {
    $git_commit = null;
}

$env = getenv('DEPLOY_ENV');
$manifest = [
    'schema_version' => 1,
    'name' => getenv('SNAPSHOT_NAME') ?: 'nightly',
    'env' => is_string($env) && $env !== '' ? $env : null,
    'created' => gmdate('Y-m-d\TH:i:s\Z'),
    'has_files' => file_exists("$path/files.tar.gz"),
    'created_by' => getenv('SNAPSHOT_CREATED_BY') ?: 'cron',
    'description' => (string) (getenv('SNAPSHOT_DESCRIPTION') ?: ''),
    'drupal_version' => $drupal_version,
    'git_commit' => $git_commit,
    'artifacts' => $artifacts,
];

$json = json_encode($manifest, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
if ($json === false) {
    fwrite(STDERR, "Failed to encode snapshot manifest: " . json_last_error_msg() . "\n");
    exit(1);
}
if (file_put_contents("$path/snapshot.json", $json . "\n") === false) {
    fwrite(STDERR, "Failed to write snapshot manifest.\n");
    exit(1);
}

// Remove the sha256 sidecars; their values now live in the manifest.
foreach (glob("$path/*.sha256") ?: [] as $sidecar) {
    @unlink($sidecar);
}

echo "$path/snapshot.json\n";
