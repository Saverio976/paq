#!/bin/bash

cd /tmp/out

echo "chmod = [" >> ./metadata.toml

for file in $(find -type f -executable); do
    true_file="${file:2}"
    echo "    { \"path\" = \"${true_file}\", \"mode\" = \"binary\" }," >> ./metadata.toml
done

echo "]" >> ./metadata.toml
