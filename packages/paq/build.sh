#!/bin/bash
set -ex

run pdm install
# build
pdm run build

# generate files packaged to a temporary directory
mkdir -p /tmp/out/bin
cp ./paq.bin /tmp/out/bin/paq

# copy to /out
cp -r /tmp/out/* /out
