#!/bin/bash

if [ -z "$WSS" ]; then export WSS=ws://localhost:8080;fi
envsubst < /srv/studio/index.html > /tmp/index.html
cat /tmp/index.html > /srv/studio/index.html

exec "$@"
