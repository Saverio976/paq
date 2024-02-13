from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
run curl -Lo /tmp/eza.tar.gz 'https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz'
run tar -xzf /tmp/eza.tar.gz -C /tmp
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/eza-community/eza/main/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/eza-community/eza/main/LICENSE
run chmod +x /tmp/eza

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/eza /tmp/out/bin/eza
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/eza --version | head -n 2 | tail -n 1 | cut -f1 -d' ' | tr -d '\n')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
