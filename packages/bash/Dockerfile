from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl

run curl -Lo /tmp/bash 'https://cosmo.zip/pub/cosmos/bin/bash'
run curl -Lo /tmp/LICENSE.html 'https://www.gnu.org/licenses/gpl-3.0.html'
run curl -Lo /tmp/README 'https://tiswww.case.edu/php/chet/bash/README'
run chmod +x /tmp/bash

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/bash /tmp/out/bin/bash
run cp /tmp/LICENSE.html /tmp/out/LICENSE.html
run cp /tmp/README /tmp/out/README
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(sh -c '/tmp/bash --version' | head -n 1 | cut -d' ' -f4)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
