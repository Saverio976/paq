from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar xz-utils python3 python3-venv python3-pip git gcc patchelf ccache && pip install --break-system-packages pdm

run curl \
      -fsSL \
      'https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-amd64_linux.tar.xz' \
      -o upx.tar.xz \
    && tar -xf upx.tar.xz \
    && mv upx-4.2.2-amd64_linux/upx /usr/local/bin/upx \
    && rm -rf upx.tar.xz upx-4.2.2-amd64_linux

# use add to invalidate cache if sources has changed
run git clone --single-branch --branch main https://github.com/Saverio976/paq.git /paq
workdir /paq
run pdm install

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

COPY ./build.sh /build.sh

# cmd
cmd bash /build.sh
