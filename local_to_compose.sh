#!/bin/bash

echo starting...
docker compose -f docker-compose.local.yml up -d

echo copying stores to compose...
docker cp studio/data/messagestore.txt bazalt-studio-1:/srv/studio/data/messagestore.txt
docker cp store/data/messagestore.txt bazalt-store-1:/srv/store/data/messagestore.txt
docker cp dumb/data/messagestore.txt bazalt-dumb-1:/srv/dumb/data/messagestore.txt
docker cp ident/data/messagestore.txt bazalt-ident-1:/srv/ident/data/messagestore.txt

echo restarting...
docker compose -f docker-compose.local.yml restart
