#!/bin/bash

START_DIR="${START_DIR:-/home/example/project}"
PREFIX="deploy-code-server"

mkdir -p $START_DIR
cd $START_DIR

echo "[$PREFIX] Starting code-server..."
# Now we can run code-server with the default entrypoint
/usr/bin/entrypoint.sh --auth none --bind-addr 0.0.0.0:8080 $START_DIR