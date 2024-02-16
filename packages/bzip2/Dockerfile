from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl

run curl -Lo /tmp/bzip2 'https://cosmo.zip/pub/cosmos/bin/bzip2'
run curl -Lo /tmp/LICENSE 'https://gitlab.com/bzip2/bzip2/-/raw/master/COPYING?ref_type=heads&inline=false'
run curl -Lo /tmp/README.md 'https://gitlab.com/bzip2/bzip2/-/raw/master/README.md?ref_type=heads&inline=false'
run chmod +x /tmp/bzip2

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/bzip2 /tmp/out/bin/bzip2
run cp /tmp/LICENSE /tmp/out/LICENSE
run cp /tmp/README.md /tmp/out/README.md
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(sh -c '/tmp/bzip2 --help 2>&1 >/dev/null' | head -n 1 | cut -d' ' -f8 | tr -d ',')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
