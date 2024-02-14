from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar

# use add to invalidate cache if sources has changed
run curl -Lo /tmp/lvtc 'https://github.com/X-R-G-B/Leviator/releases/latest/download/lvtc-linux'
run curl -Lo /tmp/lvtrun 'https://github.com/X-R-G-B/Leviator/releases/latest/download/lvtrun-linux'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/X-R-G-B/Leviator/dev/README.md'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/X-R-G-B/Leviator/dev/LICENSE'

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/lvtc /tmp/out/bin/lvtc
run cp /tmp/lvtrun /tmp/out/bin/lvtrun
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/X-R-G-B/Leviator/releases/latest' | cut -d'/' -f8)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
