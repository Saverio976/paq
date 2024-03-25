from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y make git gcc binutils

run git clone https://github.com/vlang/v.git /vlang \
    && cd /vlang \
    && make \
    && ./v symlink

# use add to invalidate cache if sources has changed
run git clone --single-branch --branch main https://github.com/Saverio976/paq.git /paq
workdir /paq
run make paq-prod

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /paq/paq /tmp/out/bin/paq
run cp /paq/README.md /tmp/out/README.md
run cp /paq/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
