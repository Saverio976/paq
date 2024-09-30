from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/ascii-image-converter/ascii-image-converter /tmp/out/bin/ascii-image-converter
run cp /tmp/ascii-image-converter/README.md /tmp/out/README.md
run cp /tmp/ascii-image-converter/LICENSE.txt /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/ascii-image-converter --version)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
