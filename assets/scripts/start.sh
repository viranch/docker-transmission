#!/bin/bash

mkdir -p /data/{transmission,watch,downloads}
test -f /data/transmission/settings.json || cp /opt/transmission.json /data/transmission/settings.json
test -L /var/www/html/downloads || ln -s /{data,var/www/html}/downloads

exec "$@"
