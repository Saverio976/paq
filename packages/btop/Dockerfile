from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar bzip2

# get binary + files
run curl -Lo /tmp/btop.tbz 'https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz'
run tar xf /tmp/btop.tbz -C /tmp

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/btop/bin/btop /tmp/out/bin/btop
run cp /tmp/btop/README.md /tmp/out/README.md
run cp /tmp/btop/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/btop --version | cut -d' ' -f3 | tr -d '\n')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
