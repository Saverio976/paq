#!/bin/bash

# flashbacktothefuture/bin
PATH_BIN=$(dirname "$(readlink -f "$0")")

ARGS=${@:1}

# flashbacktothefuture
PATH_BIN=$(dirname "$PATH_BIN")

(
    export LD_LIBRARY_PATH="$PATH_BIN/libs:$LD_LIBRARY_PATH"
    exec $PATH_BIN/tor-browser/Browser/start-tor-browser ${ARGS}
)
