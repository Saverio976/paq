#!/bin/bash

rm -rf /tmp/packages
mkdir -p /tmp/packages
rm -rf /tmp/packages-failed.log

MAX_CONCURRENT=10
NB_CONCURRENT_NOW=0

build_package() {
    FILE="$1"
    status=0
    echo "Building $FILE"
    rm -rf "/tmp/out-$(basename "$FILE")"
    rm -rf "/tmp/out-$(basename "$FILE").zip"
    rm -rf "/tmp/out-$(basename "$FILE").log"
    (
        set -ex
        exec 3>&1 4>&2 > "/tmp/out-$(basename "$FILE").log" 2>&1
        echo "Building $FILE"
        cd "$FILE"
        mkdir "/tmp/out-$(basename "$FILE")"
        docker build . -t "package-tmp-$(basename "$FILE")"
        docker run --rm -v "/tmp/out-$(basename "$FILE"):/out" "package-tmp-$(basename "$FILE")"
        (cd "/tmp/out-$(basename "$FILE")" && zip -r "/tmp/out-$(basename "$FILE").zip" .)
        cp "/tmp/out-$(basename "$FILE").zip" "/tmp/packages/$(basename "$FILE").zip"
    )
    if [ "$?" -ne "0" ]
    then
        echo "Failed to build $FILE"
        echo "Failed to build $FILE" >> "/tmp/packages-failed.log"
        cat "/tmp/out-$(basename "$FILE").log"
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
