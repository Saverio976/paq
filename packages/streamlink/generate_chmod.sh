#!/bin/bash

echo "chmod = [" >> /tmp/out/metadata.toml

for file in /tmp/out/usr/bin/*; do
    true_file="usr/bin/$(basename "$file")"
    echo "    { \"path\" = \"${true_file}\", \"mode\" = \"binary\" }," >> /tmp/out/metadata.toml
done

echo "]" >> /tmp/out/metadata.toml
