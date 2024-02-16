from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip
run curl -Lo /tmp/glados-bin "https://github.com/Mareaucanard/GLaDOS-epitech-2026/releases/latest/download/glados"
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/Mareaucanard/GLaDOS-epitech-2026/master/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/Mareaucanard/GLaDOS-epitech-2026/master/LICENSE
run chmod +x /tmp/glados-bin

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/glados-bin /tmp/out/bin/glados-bin
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/Mareaucanard/GLaDOS-epitech-2026/releases/latest' | cut -d'/' -f8)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
