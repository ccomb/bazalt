#!/bin/bash
# Proves every message survives a Haskell to Elm round trip: Haskell writes
# messages, the generated Elm codecs decode and re-encode them, Haskell
# checks it reads back the same values.
set -euo pipefail
cd "$(dirname "$0")/.."

dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT

cabal run -v0 bazalt-fixtures > "$dir/in.jsonl"
node studio/front/tests/roundtrip.mjs < "$dir/in.jsonl" > "$dir/out.jsonl"
ROUNDTRIP_DIR="$dir" cabal test -v0 bazalt-message-test --test-options='-m Cross --fail-on=pending'
