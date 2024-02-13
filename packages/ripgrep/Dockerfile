from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/ripgrep/rg /tmp/out/bin/rg
run cp /tmp/ripgrep/README.md /tmp/out/README.md
run cp /tmp/ripgrep/LICENSE-MIT /tmp/out/LICENSE
run cp -r /tmp/ripgrep/complete /tmp/out/complete
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/rg --version | head -n 1 | cut -d' ' -f2 | tr -d '\n')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
