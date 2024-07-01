from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/lfs-dal /tmp/out/bin/lfs-dal
run curl -Lo /tmp/out/README.md 'https://raw.githubusercontent.com/regen100/lfs-dal/main/README.md'
run curl -Lo /tmp/out/LICENSE 'https://raw.githubusercontent.com/regen100/lfs-dal/main/LICENSE'
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/lfs-dal --version | head -n 1 | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
