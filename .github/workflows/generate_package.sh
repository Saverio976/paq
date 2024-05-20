#!/bin/bash

get_tmp_zip() {
    FILE="$1"
    echo "/tmp/out-$(basename "$FILE").zip"
}

get_target_zip() {
    FILE="$1"
    mkdir -p "/tmp/packages"
    echo "/tmp/packages/$(basename "$FILE").zip"
}

get_log() {
    FILE="$1"
    echo "/tmp/out-$(basename "$FILE").log"
}

get_tmp_dir() {
    FILE="$1"
    echo "/tmp/out-$(basename "$FILE")-dir"
}

build_package() {
    FILE="$1"
    VERBOSE="$2"
    status=0
    echo "Building $FILE: ..."
    LOG_FILE="$(get_log "$FILE")"
    TMP_DIR="$(get_tmp_dir "$FILE")"
    TMP_ZIP="$(get_tmp_zip "$FILE")"
    TARGET_ZIP="$(get_target_zip "$FILE")"
    rm -rf "$TMP_DIR"
    rm -rf "$TMP_ZIP"
    rm -rf "$TMP_ZIP"
    (
        exec 3>&1 4>&2 > "$LOG_FILE" 2>&1
        set -ex
        echo "Building $FILE"
        cd "$FILE"
        mkdir "$TMP_DIR"
        docker build . -t "package-tmp-$(basename "$FILE")"
        docker run \
            --rm \
            -v "$TMP_DIR:/out" \
            "package-tmp-$(basename "$FILE")"
        (cd "$TMP_DIR" && zip -r "$TMP_ZIP" . || true)
        cp "$TMP_ZIP" "$TARGET_ZIP"
    )
    if [ "$?" -ne "0" ]
    then
        echo "Failed $FILE: KO"
        echo "Failed to build $FILE" >> "/tmp/packages-failed.log"
        cat "$LOG_FILE"
        status=1
    elif [[ "$VERBOSE" == "-v" ]]
    then
        cat "$LOG_FILE"
    else
        echo "Built $FILE: OK"
    fi
    return "$status"
}

build_package "$1" "$2"
