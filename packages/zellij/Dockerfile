from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
run curl -Lo /tmp/zellij.tar.gz 'https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz'
run tar -xzf /tmp/zellij.tar.gz -C /tmp
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/zellij-org/zellij/main/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/zellij-org/zellij/main/LICENSE.md
run chmod +x /tmp/zellij

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/zellij /tmp/out/bin/zellij
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/zellij --version | cut -f2 -d' ')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
