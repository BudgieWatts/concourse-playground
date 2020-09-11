#!/bin/bash

PLATFORM=linux # darwin windows
FLY=./ci/bin/fly

curl https://concourse-ci.org/docker-compose.yml > docker-compose.yml
docker-compose up -d
trap "echo stopping docker; docker-compose down; exit" SIGHUP SIGTERM SIGINT

curl --retry 3 --retry-delay 5 "http://localhost:8080/api/v1/cli?arch=amd64&platform=$PLATFORM" > $FLY

chmod +x $FLY

$FLY -t ci login -c http://127.0.0.1:8080 -u test -p test

$FLY -t ci set-pipeline -p pipeline -c ./ci/pipeline.yml
