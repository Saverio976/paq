#!/bin/bash

# flashbacktothefuture/bin
PATH_BIN=$(dirname "$(readlink -f "$0")")

# flashbacktothefuture
PATH_BIN=$(dirname "$PATH_BIN")

(
    cd "$PATH_BIN"
    chmod +x ./my_rpg
    export LD_LIBRARY_PATH="$PATH_BIN/libs:$LD_LIBRARY_PATH"
    exec ./my_rpg
)
