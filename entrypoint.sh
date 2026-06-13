#!/bin/bash
cd /home/container

# Debug (opzionale)
php -v

# Replace Pterodactyl variables
MODIFIED_STARTUP=$(eval echo "$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')")

echo ":/home/container$ ${MODIFIED_STARTUP}"

# Runtime safe dirs
mkdir -p /tmp/apache

export APACHE_RUN_DIR=/tmp
export TMPDIR=/tmp

# IMPORTANT: keep process alive
exec ${MODIFIED_STARTUP}
