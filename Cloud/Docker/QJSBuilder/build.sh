#!/bin/bash

set -e

cd $(dirname $0)
FUZZILLI_ROOT=../../..

# Setup build context
REV=$(cat $FUZZILLI_ROOT/Targets/QJS/REVISION)
cp -R $FUZZILLI_ROOT/Targets/QJS/Patches .
cp $FUZZILLI_ROOT/Targets/QJS/fuzzbuild.sh .

# Fetch the source code, apply patches, and compile the engine
docker build --build-arg rev=$REV -t qjs_builder .

# Copy build products
mkdir -p out
docker create --privileged --name temp_container qjs_builder
docker start -a temp_container
docker cp temp_container:/home/builder/quickjs/qjs out/qjs
docker rm temp_container

# Clean up
rm -r Patches
rm fuzzbuild.sh
