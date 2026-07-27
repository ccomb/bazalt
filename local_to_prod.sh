#!/bin/bash

scp studio/data/messagestore.txt modelyz:/tmp/studio.messagestore.txt
scp store/data/messagestore.txt modelyz:/tmp/store.messagestore.txt
scp dumb/data/messagestore.txt modelyz:/tmp/dumb.messagestore.txt
scp ident/data/messagestore.txt modelyz:/tmp/ident.messagestore.txt

ssh modelyz docker cp /tmp/studio.messagestore.txt bazalt-studio-1:/srv/studio/data/messagestore.txt
ssh modelyz docker cp /tmp/store.messagestore.txt bazalt-store-1:/srv/store/data/messagestore.txt
ssh modelyz docker cp /tmp/dumb.messagestore.txt bazalt-dumb-1:/srv/dumb/data/messagestore.txt
ssh modelyz docker cp /tmp/ident.messagestore.txt bazalt-ident-1:/srv/ident/data/messagestore.txt

ssh modelyz docker restart bazalt-studio-1
ssh modelyz docker restart bazalt-store-1
ssh modelyz docker restart bazalt-dumb-1
ssh modelyz docker restart bazalt-ident-1
