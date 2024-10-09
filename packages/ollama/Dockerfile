from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# use add to invalidate cache if sources has changed
run curl -Lo /tmp/ollama.tgz 'https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/ollama/ollama/main/README.md'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/ollama/ollama/main/LICENSE'
run tar xvf /tmp/ollama.tgz -C /tmp

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/bin/ollama /tmp/out/ollama
run cp -r /tmp/lib/ /tmp/out/lib/
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./ollama.sh /tmp/out/bin/ollama
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/bin/ollama -v | tail -n 1 | cut -d' ' -f5)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
