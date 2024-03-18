from debian:12-slim

run apt-get update -y && apt-get install -y curl tar gzip

run mkdir -p /tmp/out
run curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix /tmp/out
run curl -Lo /tmp/out/LICENSE 'https://raw.githubusercontent.com/89luca89/distrobox/main/COPYING.md'
run curl -Lo /tmp/out/README.md 'https://raw.githubusercontent.com/89luca89/distrobox/main/docs/README.md'

run mkdir -p /tmp/out/completions
run mv /tmp/out/share/bash-completion/completions /tmp/out/completions/bash
run mv /tmp/out/share/zsh/site-functions /tmp/out/completions/zsh
run mv /tmp/out/share/man /tmp/out/man
run rm -rf /tmp/out/share
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/distrobox --version | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml
run echo "binaries = [" >> /tmp/out/metadata.toml
run for file in /tmp/out/bin/distrobox* ; do echo "    \"bin/$(basename "$file")\"," >> /tmp/out/metadata.toml; done
run echo "]" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
