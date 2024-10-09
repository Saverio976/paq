#!/bin/bash

# ollama/bin
PATH_BIN=$(dirname "$(readlink -f "$0")")

ARGS=${@:1}
ARGS=$(printf "'%s' " "${ARGS[@]}")

# ollama
PATH_BIN=$(dirname "$PATH_BIN")

(
    export LD_LIBRARY_PATH="$PATH_BIN/lib/ollama:$LD_LIBRARY_PATH"
    exec "$PATH_BIN/ollama" $ARGS
)
