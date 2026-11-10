#!/usr/bin/env sh
set -eu

# Per RFC 9309 (Robots Exclusion Protocol), multiple blocks for the same
# User-agent are combined into a single effective rule set rather than
# overriding previous entries. User-agent: * rules are not inherited by more
# specific user agents; each matching user agent group stands on its own and
# path matching follows longest-match rules.
# @SEE https://www.rfc-editor.org/rfc/rfc9309.html

ROBOTS_FILE="$APP_WEBROOT/robots.txt"

if [ ! -d "$APP_WEBROOT" ]; then
  echo "[robots.txt] APP_WEBROOT '$APP_WEBROOT' missing; skipping." >&2
  exit 0
fi

if [ -n "${ROBOTS_TXT_REPLACE:-}" ] && [ -n "${ROBOTS_TXT_APPEND:-}" ]; then
  echo "[robots.txt] WARNING: both ROBOTS_TXT_REPLACE and ROBOTS_TXT_APPEND set; REPLACE wins." >&2
fi

if [ -n "${ROBOTS_TXT_REPLACE:-}" ]; then
  printf '%s\n' "$ROBOTS_TXT_REPLACE" > "$ROBOTS_FILE"
  echo "[robots.txt] replaced ($(wc -c < "$ROBOTS_FILE") bytes)."
elif [ -n "${ROBOTS_TXT_APPEND:-}" ]; then
  if [ -s "$ROBOTS_FILE" ] && [ "$(tail -c1 "$ROBOTS_FILE" | wc -l)" -eq 0 ]; then
    printf '\n' >> "$ROBOTS_FILE"
  fi
  printf '%s\n' "$ROBOTS_TXT_APPEND" >> "$ROBOTS_FILE"
  echo "[robots.txt] appended ($(wc -c < "$ROBOTS_FILE") bytes)."
else
  exit 0
fi

chown "$NGINX_RUN_USER":"$NGINX_RUN_GROUP" "$ROBOTS_FILE"
chmod 644 "$ROBOTS_FILE"
