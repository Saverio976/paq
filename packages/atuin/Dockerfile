from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
#run mkdir -p /tmp/out/completions/bash
#run mkdir -p /tmp/out/completions/zsh
#run mkdir -p /tmp/out/completions/nushell
#run mkdir -p /tmp/out/completions/fish
run cp /tmp/atuin/atuin /tmp/out/bin/atuin
run cp /tmp/atuin/README.md /tmp/out/README.md
run cp /tmp/atuin/LICENSE /tmp/out/LICENSE
#run cp /tmp/atuin/completions/atuin.bash /tmp/out/completions/bash/atuin.bash
#run cp /tmp/atuin/completions/_atuin /tmp/out/completions/zsh/_atuin
#run cp /tmp/atuin/completions/atuin.nu /tmp/out/completions/nushell/atuin.nu
#run cp /tmp/atuin/completions/atuin.fish /tmp/out/completions/fish/atuin.fish
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/atuin --version | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
