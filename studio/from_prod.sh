#!/bin/bash

ssh studio docker cp bazalt-studio-1:/srv/data/eventstore.txt /tmp/
scp studio:/tmp/eventstore.txt data/

