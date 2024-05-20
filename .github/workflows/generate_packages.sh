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
        if [[ "$file" == "$not_process" ]]; then
            echo "Not processing $file"
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
    time ./.github/workflows/generate_package.sh "$file" &
done

wait $(jobs -rp)
exit 0
