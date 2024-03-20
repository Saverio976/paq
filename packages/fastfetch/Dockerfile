from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl gzip

run curl -Lo /tmp/fastfetch.tar.gz 'https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz'
run tar xf /tmp/fastfetch.tar.gz -C /tmp
run mv /tmp/fastfetch-linux-amd64 /tmp/fastfetch
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/fastfetch-cli/fastfetch/master/README.md'

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run mkdir -p /tmp/out/completions/bash
run mkdir -p /tmp/out/completions/fish
run cp /tmp/fastfetch/usr/bin/fastfetch /tmp/out/bin/fastfetch
run cp /tmp/fastfetch/usr/bin/flashfetch /tmp/out/bin/flashfetch
run cp -r /tmp/fastfetch/usr/share/licenses /tmp/out/licenses
run cp -r /tmp/fastfetch/usr/share/fastfetch/presets /tmp/out/presets
run cp /tmp/fastfetch/usr/share/bash-completion/completions/fastfetch /tmp/out/completions/bash/fastfetch
run cp /tmp/fastfetch/usr/share/fish/vendor_completions.d/fastfetch.fish /tmp/out/completions/fish/fastfetch.fish
run cp -r /tmp/fastfetch/usr/share/man /tmp/out/man
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/fastfetch/usr/share/licenses/fastfetch/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/fastfetch --version | head -n 1 | cut -f2 -d' ')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
