<?php

use \Drupal\update\UpdateManagerInterface;

module_load_include('inc', 'update', 'update.report');

$projects =[];
if ($available = update_get_available(TRUE)) {
  module_load_include('inc', 'update', 'compare');
  $projects = update_calculate_project_data($available);
  @template_preprocess_update_project_status($projects);
}

$updates = [];
foreach ($projects as $project) {
  // If project needs update.
  if (isset($project['recommended'])) {
    if ($project['status'] != UpdateManagerInterface::CURRENT || $project['existing_version'] !== $project['recommended']) {

      // Set the project status details.
      $status_label = NULL;
      switch ($project['status']) {
        case UpdateManagerInterface::NOT_SECURE:
          $status_label = 'Security update required!';
          break;
        case UpdateManagerInterface::REVOKED:
          $status_label = 'Revoked!';
          break;
        case UpdateManagerInterface::NOT_SUPPORTED:
          $status_label = 'Not supported!';
          break;
        case UpdateManagerInterface::NOT_CURRENT:
          $status_label = 'Update available';
          break;
        case UpdateManagerInterface::CURRENT:
          $status_label = 'Up to date';
          break;
      }
      $updates[$project['name']] = [
        'existing_version' => $project['existing_version'],
        'recommended' => $project['recommended'],
        'status' => $status_label,
      ];
    }
  }
}

// Output needed updates.
if (!empty($updates)) {
  echo "name,existing_version,recommended,status\n";
  foreach ($updates as $project_name => $project) {
    echo "{$project_name},{$project['existing_version']},{$project['recommended']},{$project['status']}\n";
  }
}
