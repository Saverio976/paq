from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/
run cp -r /tmp/d2/* /tmp/out/
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/d2 --version)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
