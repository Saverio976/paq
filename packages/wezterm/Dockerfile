from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/wez/wezterm/main/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/wez/wezterm/main/LICENSE.md

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/
run cp -r /tmp/wezterm/* /tmp/out/
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/wezterm --version | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
