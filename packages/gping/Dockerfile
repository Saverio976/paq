from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# use add to invalidate cache if sources has changed
run curl -Lo /tmp/gping.tar 'https://github.com/orf/gping/releases/latest/download/gping-x86_64-unknown-linux-musl.tar.gz'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/orf/gping/master/readme.md'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/orf/gping/master/LICENSE'
run tar xf /tmp/gping.tar -C /tmp
run chmod +x /tmp/gping

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/gping /tmp/out/bin/gping
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/gping --version | head -n 1 | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
