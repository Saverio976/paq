#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/sharkdp/bat/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/bat.tar.gz "https://github.com/sharkdp/bat/releases/latest/download/bat-${version}-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/bat.tar.gz -C /tmp
mv "/tmp/bat-${version}-x86_64-unknown-linux-musl" /tmp/bat
