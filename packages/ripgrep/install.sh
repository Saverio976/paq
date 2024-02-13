#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/BurntSushi/ripgrep/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/ripgrep.tar.gz "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/ripgrep.tar.gz -C /tmp
mv "/tmp/ripgrep-${version}-x86_64-unknown-linux-musl" /tmp/ripgrep
