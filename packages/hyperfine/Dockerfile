from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/hyperfine/hyperfine /tmp/out/bin/hyperfine
run cp /tmp/hyperfine/README.md /tmp/out/README.md
run cp /tmp/hyperfine/LICENSE-MIT /tmp/out/LICENSE
run cp -r /tmp/hyperfine/autocomplete /tmp/out/autocomplete
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/hyperfine --version | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
