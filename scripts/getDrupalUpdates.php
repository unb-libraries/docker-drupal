<?php

use \Drupal\update\UpdateManagerInterface;

class DrupalUpdates{

  public static function getModuleUpdates($security_only = FALSE) {

    module_load_include('inc', 'update', 'update.report');

    $projects =[];
    update_refresh();
    if ($available = update_get_available(TRUE)) {
      module_load_include('inc', 'update', 'compare');
      $projects = update_calculate_project_data($available);
      @template_preprocess_update_project_status($projects);
    }

    $updates = [];
    foreach ($projects as $project) {
      // If project needs update.
      if (isset($project['recommended']) || $project['project_status'] == 'unsupported') {
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

          if (!$security_only || $project['status'] == UpdateManagerInterface::NOT_SECURE || $project['status'] == UpdateManagerInterface::NOT_SUPPORTED) {
            $updates[] = [
              'name' => $project['name'],
              'existing_version' => $project['existing_version'],
              'recommended' => $project['recommended'],
              'status' => $status_label,
            ];
          }
        }
      }
    }
    echo json_encode($updates);
  }

}

DrupalUpdates::getModuleUpdates(
  in_array(
    '--security',
    $_SERVER['argv']
  )
);
