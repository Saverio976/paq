#!/bin/bash

# alacritty/bin
PATH_BIN=$(dirname "$(readlink -f "$0")")

# alacritty
PATH_BIN=$(dirname "$PATH_BIN")

(
    cd "$PATH_BIN"
    export LD_LIBRARY_PATH="$PATH_BIN/libs:$LD_LIBRARY_PATH"
    tic -xe alacritty,alacritty-direct "$PATH_BIN/alacritty.info"
    exec ./alacritty
)
