from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl

# get binary + files
run curl -Lo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
run tar -xzf /tmp/nvim-linux64.tar.gz -C /tmp
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/neovim/neovim/master/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/neovim/neovim/master/LICENSE.txt

# generate files packaged to a temporary directory
run mkdir -p /tmp/out
run cp -r /tmp/nvim-linux64/* /tmp/out/
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/nvim --version | head -n 1 | cut -d' ' -f2 | tr -d '\n')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
