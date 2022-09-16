#!/bin/sh
docker build \
    --network host \
    --build-arg USER=developer \
    -t cloud_compare \
    -f Dockerfile . "$@"