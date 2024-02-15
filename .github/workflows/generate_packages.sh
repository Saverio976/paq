#!/bin/bash

rm -rf /tmp/packages
mkdir -p /tmp/packages
rm -rf /tmp/packages-failed.log

MAX_CONCURRENT=10
NOT_PROCESS=(${@:1})

for file in ./packages/*
do
    if [ ! -d "$file" ]
    then
        continue
    fi
    found=0
    for not_process in "${NOT_PROCESS[@]}"; do
        echo "Not processing $not_process"
        if [[ "$file" == "$not_process" ]]; then
            found=1
            break
        fi
    done
    if [ "$found" -eq "1" ]; then
        continue
    fi

    while [ "$(jobs -rp | wc -l)" -ge "$MAX_CONCURRENT" ]
    do
        sleep 1
    done
    ./.github/workflows/generate_package.sh "$file" &
done

wait $(jobs -rp)
exit 0
