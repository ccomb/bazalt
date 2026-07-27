#!/bin/bash

set -e
cd "$(dirname "$0")"
mkdir -p build data

if which cabal-cache >/dev/null 2>&1 && [ -f ./dist-newstyle/cache/plan.json ]; then
    cabal-cache sync-from-archive --threads 4 --archive-uri s3://cabal-store.prelab.fr --host-name-override=s3.fr-par.scw.cloud --host-port-override=443 --host-ssl-override=True --region fr-par
fi

cabal build all --ghc-options="-Wall"
cabal install studio store ident dumb --installdir=build --overwrite-policy=always --install-method=copy

if which cabal-cache >/dev/null 2>&1; then
    cabal-cache sync-to-archive --threads 4 --archive-uri s3://cabal-store.prelab.fr --host-name-override=s3.fr-par.scw.cloud --host-port-override=443 --host-ssl-override=True --region fr-par
fi
