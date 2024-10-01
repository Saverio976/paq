from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/astral-sh/uv/refs/heads/main/LICENSE-MIT'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/astral-sh/uv/refs/heads/main/README.md'

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/uv/uv /tmp/out/bin/uv
run cp /tmp/uv/uvx /tmp/out/bin/uvx
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/uv --version | cut -f2 -d' ')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
