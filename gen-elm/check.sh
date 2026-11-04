#!/bin/bash
# Fails if the committed Elm ontology differs from what the Haskell types
# generate, or if the studio does not compile against it.
set -euo pipefail
cd "$(dirname "$0")/.."

fresh=$(mktemp -d)
trap 'rm -rf "$fresh"' EXIT

cabal run -v0 bazalt-gen-elm -- "$fresh"
if ! diff -r "$fresh" studio/front/generated; then
    echo "studio/front/generated is stale: run cabal run bazalt-gen-elm -- studio/front/generated" >&2
    exit 1
fi

cd studio/front
elm make generated/Ontology/Message.elm --output=/dev/null
elm make src/Main.elm --output=/dev/null
