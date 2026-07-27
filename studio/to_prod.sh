#!/bin/bash

set -e

DB=$1
if [ "$DB" = "" ]; then echo "Need DB file path as 1st argument"; exit 1; fi
scp $DB modelyz:/tmp/
ssh modelyz docker cp /tmp/`basename $DB` bazalt-studio-1:/srv/studio/data/messagestore.txt
ssh modelyz docker restart bazalt-studio-1
