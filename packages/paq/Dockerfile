from python:3.11

# install deps
run apt-get update -y
run apt-get install -y git gcc patchelf
run pip install pdm

# build
run git clone https://github.com/Saverio976/paq.git /paq
workdir /paq
run git checkout main
run pdm install
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
