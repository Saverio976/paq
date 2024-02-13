#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/sharkdp/fd/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/fd.tar.gz "https://github.com/sharkdp/fd/releases/latest/download/fd-${version}-i686-unknown-linux-musl.tar.gz"
tar xf /tmp/fd.tar.gz -C /tmp
mv "/tmp/fd-${version}-i686-unknown-linux-musl" /tmp/fd
