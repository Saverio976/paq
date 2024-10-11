from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl

run curl -Lo /tmp/python 'https://cosmo.zip/pub/cosmos/bin/python'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/python/cpython/main/LICENSE'
run curl -Lo /tmp/README.rst 'https://raw.githubusercontent.com/python/cpython/main/README.rst'
run chmod +x /tmp/python

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/python /tmp/out/bin/python
run cp /tmp/LICENSE /tmp/out/LICENSE
run cp /tmp/README.rst /tmp/out/README.md
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(sh -c '/tmp/python --version' | cut -f2 -d' ')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
