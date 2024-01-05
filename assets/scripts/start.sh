#!/bin/bash

test -f /config/settings.json || cp /opt/transmission.json /config/settings.json

exec "$@"
