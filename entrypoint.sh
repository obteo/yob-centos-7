#!/bin/bash

# pulizia runtime
rm -rf /run/httpd/*

# assicurati directory container
mkdir -p /home/container/public_html
chown -R apache:apache /home/container

# usa /tmp invece di /run (CRITICO)
export APACHE_RUN_DIR=/tmp
export PIDFILE=/tmp/httpd.pid

# avvio apache con config sicura
exec httpd -DFOREGROUND -c "PidFile /tmp/httpd.pid"
