#!/usr/bin/env sh
DOAS_CONF='/etc/doas.conf'
chmod +w "$DOAS_CONF"
echo "permit nopass keepenv root as nginx" >> "$DOAS_CONF"
chmod -w "$DOAS_CONF"
