#!/bin/bash
cd /home/container

# Output PHP version (debug utile)
php -v

# ----------------------------------
# Replace Startup Variables (Pterodactyl standard)
# ----------------------------------
MODIFIED_STARTUP=$(eval echo "$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')")

echo ":/home/container$ ${MODIFIED_STARTUP}"

# ----------------------------------
# Fix runtime dirs (NO permissions required hacks)
# ----------------------------------
mkdir -p /tmp/apache

export APACHE_RUN_DIR=/tmp
export TMPDIR=/tmp

# ----------------------------------
# Run the Server
# ----------------------------------
exec ${MODIFIED_STARTUP}
