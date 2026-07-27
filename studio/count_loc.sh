#!/bin/bash

for commit in $(git rev-list main)
do
    git co $commit
    cloc . --csv | grep Elm | cut -d, -f5 >> lines.txt
done
