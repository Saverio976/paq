from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# use add to invalidate cache if sources has changed
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/ulyssa/iamb/main/README.md'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/ulyssa/iamb/main/LICENSE'

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/iamb/iamb /tmp/out/bin/iamb
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
run cp -r /tmp/iamb/docs /tmp/out
run cp /tmp/iamb/config.example.toml /tmp/out/config.example.toml
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/iamb/iamb --version | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
