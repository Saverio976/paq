from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl

run curl -Lo /tmp/vim 'https://cosmo.zip/pub/cosmos/bin/vim'
run curl -Lo /tmp/LICENSE 'https://github.com/vim/vim/raw/master/LICENSE'
run curl -Lo /tmp/README.md 'https://github.com/vim/vim/raw/master/README.md'
run chmod +x /tmp/vim

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/vim /tmp/out/bin/vim
run cp /tmp/LICENSE /tmp/out/LICENSE
run cp /tmp/README.md /tmp/out/README.md
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/vim --version | head -n 1 | cut -f5 -d' ' | tr -d '\n')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
