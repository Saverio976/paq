from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
run curl -Lo /tmp/container2wasm.tar.gz "https://github.com/ktock/container2wasm/releases/latest/download/container2wasm-$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/ktock/container2wasm/releases/latest' | cut -d'/' -f8)-linux-amd64.tar.gz"
run tar -xzf /tmp/container2wasm.tar.gz -C /tmp
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/ktock/container2wasm/main/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/ktock/container2wasm/main/LICENSE
run chmod +x /tmp/c2w
run chmod +x /tmp/c2w-net

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/c2w /tmp/out/bin/c2w
run cp /tmp/c2w-net /tmp/out/bin/c2w-net
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/bin/c2w --version | cut -f3 -d' ')\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
