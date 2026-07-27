#!/bin/bash

ssh modelyz docker cp bazalt-store-1:/srv/store/data/messagestore.txt /tmp/store.messagestore.txt
ssh modelyz docker cp bazalt-studio-1:/srv/studio/data/messagestore.txt /tmp/studio.messagestore.txt
ssh modelyz docker cp bazalt-dumb-1:/srv/dumb/data/messagestore.txt /tmp/dumb.messagestore.txt
ssh modelyz docker cp bazalt-ident-1:/srv/ident/data/messagestore.txt /tmp/ident.messagestore.txt

scp modelyz:/tmp/store.messagestore.txt store/data/messagestore.txt
scp modelyz:/tmp/studio.messagestore.txt studio/data/messagestore.txt
scp modelyz:/tmp/dumb.messagestore.txt dumb/data/messagestore.txt
scp modelyz:/tmp/ident.messagestore.txt ident/data/messagestore.txt

