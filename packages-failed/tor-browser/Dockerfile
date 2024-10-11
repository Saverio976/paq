from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar xz-utils libdbus-glib-1-2

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run mkdir -p /tmp/out/libs
run mv /tmp/tor-browser /tmp/out/tor-browser
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE.html /tmp/out/LICENSE.html
run cp /usr/lib/x86_64-linux-gnu/libdbus-glib-1.so.2 /tmp/out/libs/libdbus-glib-1.so.2
COPY ./metadata.toml /tmp/out/metadata.toml
COPY ./tor-browser.sh /tmp/out/bin/tor-browser
run echo "version = \"$(cat /tmp/version)\"" >> /tmp/out/metadata.toml
COPY ./generate_chmod.sh /tmp/generate_chmod.sh
run bash /tmp/generate_chmod.sh

# cmd
cmd cp -r /tmp/out/* /out
