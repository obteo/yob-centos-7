#!/bin/bash
cd /home/container

php -v

MODIFIED_STARTUP=$(eval echo "$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')")

echo ":/home/container$ ${MODIFIED_STARTUP}"

mkdir -p /tmp/apache

export APACHE_RUN_DIR=/tmp
export TMPDIR=/tmp

exec ${MODIFIED_STARTUP}
