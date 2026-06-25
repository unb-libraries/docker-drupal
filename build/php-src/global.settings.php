<?php

/**
 * @file
 * Global settings include, baked into every UNB Drupal image at /app/php.
 *
 * Wired into sites/default/settings.php by pre-init.d/62_add_global_settings_include.sh.
 * Guarded so a missing baked file degrades gracefully instead of fataling the
 * site bootstrap.
 */

if (file_exists('/app/php/ContainerStderrLogger.php') && file_exists('/app/php/services.yml')) {
  require_once '/app/php/ContainerStderrLogger.php';
  $settings['container_yamls'][] = '/app/php/services.yml';
}
