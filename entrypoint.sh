#!/bin/bash

echo "[XLRSTATS] Starting Apache..."

mkdir -p /home/container/public_html

exec /usr/sbin/httpd -D FOREGROUND
