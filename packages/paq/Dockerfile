from python:3.11

# install deps
run apt-get update -y
run apt-get install -y git gcc patchelf ccache
run pip install pdm

run curl \
      -fsSL \
      'https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-amd64_linux.tar.xz' \
      -o upx.tar.xz \
    && tar -xf upx.tar.xz \
    && mv upx-4.2.2-amd64_linux/upx /usr/local/bin/upx \
    && rm -rf upx.tar.xz upx-4.2.2-amd64_linux

# use add to invalidate cache if sources has changed
ADD https://github.com/Saverio976/paq/archive/refs/heads/main.zip /tmp/sum
run git clone https://github.com/Saverio976/paq.git /paq
workdir /paq
run git checkout main
run git checkout "$(git describe main --tags --abbrev=0)"
run pdm install

# build
run pdm run build

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp ./paq.bin /tmp/out/bin/paq
run cp ./README.md /tmp/out/README.md
run cp ./LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
