#!/bin/bash

echo starting...
docker compose -f docker-compose.local.yml up -d

echo copying stores to compose...
docker cp studio/data/messagestore.txt modelyz-studio-1:/srv/studio/data/messagestore.txt
docker cp store/data/messagestore.txt modelyz-store-1:/srv/store/data/messagestore.txt
docker cp dumb/data/messagestore.txt modelyz-dumb-1:/srv/dumb/data/messagestore.txt
docker cp ident/data/messagestore.txt modelyz-ident-1:/srv/ident/data/messagestore.txt

echo restarting...
docker compose -f docker-compose.local.yml restart
