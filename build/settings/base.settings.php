<?php
/*
Include all settings overrides here
# require_once 'settings_file.inc';
*/

// Load environment based includes.
if (isset($_SERVER['APPLICATION_ENV'])) {
  $environment = strtolower($_SERVER['APPLICATION_ENV']);
  $environment_include = dirname(__FILE__) . "/settings.$environment.inc";
  if (file_exists($environment_include)) {
    include_once $environment_include;
  }
}

// Add common includes below.
