#!/bin/bash

rm -rf /tmp/packages
mkdir -p /tmp/packages
rm -rf /tmp/packages-failed.log

MAX_CONCURRENT=10
NB_CONCURRENT_NOW=0

get_tmp_zip() {
    FILE="$1"
    echo "/tmp/out-$(basename "$FILE").zip"
}

get_target_zip() {
    FILE="$1"
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
    status=0
    echo "Building $FILE"
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
        docker run --rm -v "$TMP_DIR:/out" "package-tmp-$(basename "$FILE")"
        (cd "$TMP_DIR" && zip -r "$TMP_ZIP" .)
        cp "$TMP_ZIP" "$TARGET_ZIP"
    )
    if [ "$?" -ne "0" ]
    then
        echo "Failed to build $FILE"
        echo "Failed to build $FILE" >> "/tmp/packages-failed.log"
        cat "$LOG_FILE"
        status=1
    fi
    NB_CONCURRENT_NOW=$((NB_CONCURRENT_NOW-1))
    return "$status"
}

for file in ./packages/*
do
    if [ -d "$file" ]
    then
        while [ "$NB_CONCURRENT_NOW" -ge "$MAX_CONCURRENT" ]
        do
            sleep 1
        done
        build_package "$file" &
        NB_CONCURRENT_NOW=$((NB_CONCURRENT_NOW+1))
    fi
done

wait $(jobs -rp)
exit 0
