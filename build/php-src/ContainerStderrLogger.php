<?php

/**
 * @file
 * Container-native stderr logger for all UNB Drupal sites.
 *
 * Routes ERROR-and-worse watchdog entries to the container's stderr stream
 * (fd 2) so they surface in `dockworker logs` / `kubectl logs` alongside the
 * nginx logs, without enabling dblog/syslog. The severity floor is the RFC
 * ERROR level by default and is configurable via:
 *   $settings['unblib_stderr_log_level'] = \Drupal\Core\Logger\RfcLogLevel::WARNING;
 *
 * Baked into the image at /app/php and registered via container_yamls; see
 * global.settings.php and services.yml in the same directory.
 */

namespace UnbLib\Logger;

use Drupal\Core\Logger\LogMessageParserInterface;
use Drupal\Core\Logger\RfcLoggerTrait;
use Drupal\Core\Logger\RfcLogLevel;
use Drupal\Core\Site\Settings;
use Psr\Log\LoggerInterface;

/**
 * Writes severe log entries to the container stderr stream.
 */
class ContainerStderrLogger implements LoggerInterface {

  use RfcLoggerTrait;

  /**
   * RFC 5424 level names, indexed by severity (lower = more severe).
   */
  private const NAMES = [
    0 => 'EMERGENCY',
    1 => 'ALERT',
    2 => 'CRITICAL',
    3 => 'ERROR',
    4 => 'WARNING',
    5 => 'NOTICE',
    6 => 'INFO',
    7 => 'DEBUG',
  ];

  /**
   * Severity floor; entries with a higher (less severe) level are dropped.
   */
  protected int $threshold;

  /**
   * Constructs the logger.
   *
   * @param \Drupal\Core\Logger\LogMessageParserInterface $parser
   *   The message placeholder parser.
   */
  public function __construct(protected LogMessageParserInterface $parser) {
    // Static accessor: no '@settings' DI dependency that could break later.
    $this->threshold = (int) Settings::get('unblib_stderr_log_level', RfcLogLevel::ERROR);
  }

  /**
   * {@inheritdoc}
   */
  public function log($level, string|\Stringable $message, array $context = []): void {
    try {
      // RFC severities: lower is more severe, so drop anything above the floor.
      if (!is_int($level) || $level > $this->threshold) {
        return;
      }
      $message = (string) $message;
      $placeholders = $this->parser->parseMessagePlaceholders($message, $context);
      $text = $placeholders ? strtr($message, $placeholders) : $message;
      $line = sprintf(
        "[%s] %s.%s: %s | uid=%s ip=%s uri=%s\n",
        gmdate('c', $context['timestamp'] ?? time()),
        self::NAMES[$level] ?? (string) $level,
        $context['channel'] ?? '',
        strip_tags($text),
        $context['uid'] ?? 0,
        $context['ip'] ?? '',
        $context['request_uri'] ?? ''
      );
      // Cache the handle for the process lifetime; never fclose() it, as that
      // would close the php-fpm worker's fd 2.
      static $stderr = NULL;
      if ($stderr === NULL) {
        $stderr = @fopen('php://stderr', 'w') ?: FALSE;
      }
      if ($stderr) {
        @fwrite($stderr, $line);
      }
    }
    catch (\Throwable $e) {
      // Never break a request because of logging.
    }
  }

}
