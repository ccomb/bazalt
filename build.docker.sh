#/bin/bash

docker build --target build --cache-from bazalt-build -t bazalt-build .
docker build --cache-from bazalt-build -t bazalt .
