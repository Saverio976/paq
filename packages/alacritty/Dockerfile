from debian:12-slim

run apt-get update -y \
    && apt-get install -y \
        cmake \
        pkg-config \
        libfreetype6-dev \
        libfontconfig1-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev \
        python3 \
        curl \
        git \
        libpng-dev \
    && rm -rf /var/lib/apt/lists/*

env PATH="$HOME/.cargo/bin:$PATH"
run curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && export PATH="$HOME/.cargo/bin:$PATH" \
    && rustup override set stable \
    && rustup update stable

run git clone --single-branch --branch master https://github.com/alacritty/alacritty.git /alacritty
workdir /alacritty

run export PATH="$HOME/.cargo/bin:$PATH" \
    && cargo build --release

run mkdir -p /tmp/out/bin
run mkdir -p /tmp/out/libs
run mkdir -p /tmp/out/completions/bash
run mkdir -p /tmp/out/completions/zsh
run cp \
        /lib/x86_64-linux-gnu/libfreetype.so.6 \
        /lib/x86_64-linux-gnu/libfontconfig.so.1 \
        /lib/x86_64-linux-gnu/libgcc_s.so.1 \
        /lib/x86_64-linux-gnu/libm.so.6 \
        /lib/x86_64-linux-gnu/libc.so.6 \
        /lib64/ld-linux-x86-64.so.2 \
        /lib/x86_64-linux-gnu/libz.so.1 \
        /lib/x86_64-linux-gnu/libpng16.so.16 \
        /lib/x86_64-linux-gnu/libbrotlidec.so.1 \
        /lib/x86_64-linux-gnu/libexpat.so.1 \
        /lib/x86_64-linux-gnu/libbrotlicommon.so.1 \
        /tmp/out/libs
run cp /alacritty/target/release/alacritty /tmp/out/alacritty
COPY ./alacritty.sh /tmp/out/bin/alacritty
run cp /alacritty/README.md /tmp/out/README.md
run cp /alacritty/LICENSE-MIT /tmp/out/LICENSE
run cp /alacritty/extra/completions/_alacritty /tmp/out/completions/zsh/_alacritty
run cp /alacritty/extra/completions/alacritty.bash /tmp/out/completions/bash/alacritty.bash
run cp /alacritty/extra/completions/alacritty.bash /tmp/out/completions/bash/alacritty.bash
run cp /alacritty/extra/alacritty.info /tmp/out/alacritty.info
run cp -r /alacritty/extra/man /tmp/out/
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(/alacritty/target/release/alacritty --version | cut -d' ' -f2)\"" >> /tmp/out/metadata.toml

cmd cp -r /tmp/out/* /out
