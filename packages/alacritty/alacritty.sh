#!/bin/bash

# alacritty/bin
PATH_BIN=$(dirname "$(readlink -f "$0")")

ARGS=${@:1}

# alacritty
PATH_BIN=$(dirname "$PATH_BIN")

(
    tic -xe alacritty,alacritty-direct "$PATH_BIN/alacritty.info"
    export LD_LIBRARY_PATH="$PATH_BIN/libs:$LD_LIBRARY_PATH"
    exec $PATH_BIN/alacritty ${ARGS}
)
