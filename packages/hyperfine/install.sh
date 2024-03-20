#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/sharkdp/hyperfine/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/hyperfine.tar.gz "https://github.com/sharkdp/hyperfine/releases/latest/download/hyperfine-${version}-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/hyperfine.tar.gz -C /tmp
mv "/tmp/hyperfine-${version}-x86_64-unknown-linux-musl" /tmp/hyperfine
