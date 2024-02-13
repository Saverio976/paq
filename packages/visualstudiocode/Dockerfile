from debian:12-slim

# install deps
run apt-get update && apt-get install -y curl tar gzip libglib2.0-0 \
                        libatk1.0-0 libnss3 libatk-bridge2.0-0 \
                        libdrm2 libgtk-3-0 libgbm1 libasound2

run curl -Lo /tmp/visualstudiocode.tar.gz 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64'
run tar -xf /tmp/visualstudiocode.tar.gz -C /tmp

# generate files packaged to a temporary directory
run mv /tmp/VSCode-linux-x64 /tmp/out
run cp /tmp/out/resources/app/LICENSE.rtf /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/code-original --no-sandbox --user-data-dir /tmp --version | head -n 1 | tr -d '\n')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
