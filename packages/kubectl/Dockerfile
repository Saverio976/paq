from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl

run curl -Lo /tmp/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

run mkdir -p /tmp/out/bin
run chmod +x /tmp/kubectl
run cp /tmp/kubectl /tmp/out/bin/kubectl
copy ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/kubectl version --client | head -n 1 | cut -f2 -d':' | tr -d ' ')\"" >> /tmp/out/metadata.toml

cmd cp -r /tmp/out/* /out
