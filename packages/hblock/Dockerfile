from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip
run curl -Lo /tmp/hblock "https://raw.githubusercontent.com/hectorm/hblock/$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/hectorm/hblock/releases/latest' | cut -d'/' -f8)/hblock"
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/hectorm/hblock/master/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/hectorm/hblock/master/LICENSE.md
run chmod +x /tmp/hblock

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/hblock /tmp/out/bin/hblock
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/hblock --version | head -n 1 | cut -f2 -d' ')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
