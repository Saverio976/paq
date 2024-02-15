from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar xz-utils

# get binary + files
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/HanabishiRecca/bin-cpuflags-x86/master/LICENSE'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/HanabishiRecca/bin-cpuflags-x86/master/README.md'
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/bin-cpuflags-x86 /tmp/out/bin/bin-cpuflags-x86
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/bin-cpuflags-x86 --help | head -n 1 | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
