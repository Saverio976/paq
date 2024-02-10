#!/bin/bash
set -ex

rm -rf /tmp/packages
mkdir -p /tmp/packages

for file in ./packages/*
do
    if [ -d "$file" ]
    then
        (
            cd "$file"
            rm -rf /tmp/out
            rm -rf /tmp/out.zip
            mkdir /tmp/out
            docker build . -t "package-tmp-$(basename "$file")"
            docker run --rm -v /tmp/out:/out "package-tmp-$(basename "$file")"
            (cd /tmp/out && zip -r /tmp/out.zip .)
            cp /tmp/out.zip "/tmp/packages/$(basename "$file").zip"
        )
    fi
done
