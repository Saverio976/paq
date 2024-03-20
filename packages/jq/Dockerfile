from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar

# use add to invalidate cache if sources has changed
run curl -Lo /tmp/jq 'https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/jqlang/jq/master/README.md'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/jqlang/jq/master/COPYING'
run chmod +x /tmp/jq

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/jq /tmp/out/bin/jq
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/jq --version | cut -d'-' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
