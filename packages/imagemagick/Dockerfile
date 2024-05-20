from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip libfreetype-dev libharfbuzz-dev libfribidi-dev jq

# get binary + files
COPY ./install.sh /tmp/install.sh
run bash /tmp/install.sh
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/ImageMagick/ImageMagick/main/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/ImageMagick/ImageMagick/main/LICENSE.md

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/
run cp -r /tmp/magick/* /tmp/out/
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
run cp \
            /lib/x86_64-linux-gnu/libfribidi.so.0 \
            /lib/x86_64-linux-gnu/libfreetype.so.6 \
            /lib/x86_64-linux-gnu/libharfbuzz.so.0 \
            /tmp/out/usr/lib/
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/tmp/out/AppRun --version | head -n 1 | cut -d' ' -f3)\"" >> /tmp/out/metadata.toml
COPY ./generate_chmod.sh /tmp/generate_chmod.sh
run bash /tmp/generate_chmod.sh

# cmd
cmd cp -r /tmp/out/* /out
