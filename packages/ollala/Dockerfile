from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar

# use add to invalidate cache if sources has changed
run curl -Lo /tmp/ollama 'https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64'
run curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/ollama/ollama/main/README.md'
run curl -Lo /tmp/LICENSE 'https://raw.githubusercontent.com/ollama/ollama/main/LICENSE'
run chmod +x /tmp/ollama

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/ollama /tmp/out/bin/ollama
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/ollama -v | tail -n 1 | cut -d' ' -f5)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
