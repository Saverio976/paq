#!/bin/bash
set -ex

pdm install
# build
pdm run build-pyinstaller
#pdm run build-nuitka

# generate files packaged to a temporary directory
mkdir -p /tmp/out/bin
#cp ./paq.bin /tmp/out/bin/paq
cp ./dist/paq /tmp/out/bin/paq

# copy to /out
cp -r /tmp/out/* /out
