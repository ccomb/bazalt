#!/bin/bash

# no directory argument: elm-review reads the source-directories of elm.json,
# generated/ included, which its config never reports nor fixes
npx elm-review --fix-all
