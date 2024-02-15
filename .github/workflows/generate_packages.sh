#!/bin/bash

rm -rf /tmp/packages
mkdir -p /tmp/packages
rm -rf /tmp/packages-failed.log

MAX_CONCURRENT=10

for file in ./packages/*
do
    if [ ! -d "$file" ]
    then
        continue
    fi
    while [ "$(jobs -rp | wc -l)" -ge "$MAX_CONCURRENT" ]
    do
        sleep 1
    done
    build_package "$file" &
done

wait $(jobs -rp)
exit 0
