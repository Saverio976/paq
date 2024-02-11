#!/bin/bash

# flashbacktothefuture/bin
PATH_BIN=$(dirname "$(readlink -f "$0")")

# flashbacktothefuture
PATH_BIN=$(dirname "$PATH_BIN")

(
    cd "$PATH_BIN"
    chmod +x ./my_rpg
    exec ./my_rpg
)
