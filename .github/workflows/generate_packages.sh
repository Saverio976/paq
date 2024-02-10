#!/bin/bash

rm -rf /tmp/packages
mkdir -p /tmp/packages
rm -rf /tmp/packages-failed.log

MAX_CONCURRENT=10
NB_CONCURRENT_NOW=0

build_package() {
    file="$1"
    echo "Building $file"
    (
        set -e
        cd "$file"
        rm -rf "/tmp/out-$(basename "$file")"
        rm -rf "/tmp/out-$(basename "$file").zip"
        rm -rf "/tmp/out-$(basename "$file").log"
        mkdir "/tmp/out-$(basename "$file")"
        docker build . -t "package-tmp-$(basename "$file")"
        docker run --rm -v "/tmp/out-$(basename "$file"):/out" "package-tmp-$(basename "$file")"
        (cd "/tmp/out-$(basename "$file")" && zip -r "/tmp/out-$(basename "$file").zip" .)
        cp "/tmp/out-$(basename "$file").zip" "/tmp/packages/$(basename "$file").zip"
    ) &>> "/tmp/out-$(basename "$file").log"
    status=0
    if [ "$?" -ne "0" ]
    then
        echo "Failed to build $file"
        echo "Failed to build $file" >> "/tmp/packages-failed.log"
        cat "/tmp/out-$(basename "$file").log"
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
