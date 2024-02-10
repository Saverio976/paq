#!/bin/bash

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
            zip -r /tmp/out.zip /tmp/out
            cp /tmp/out.zip "/tmp/packages/$(basename "$file").zip"
        )
    fi
done
