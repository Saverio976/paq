#!/bin/bash

./tools/uninstall
mkdir -p build
cd build
cmake ..
make -j2
