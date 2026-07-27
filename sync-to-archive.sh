#!/bin/bash

cabal-cache sync-to-archive --threads 4 --archive-uri s3://cabal-store.prelab.fr --host-name-override=s3.fr-par.scw.cloud --host-port-override=443 --host-ssl-override=True --region fr-par
#cabal-cache sync-to-archive --threads 4 --archive-uri ~/.cabal/archive --region fr-par
