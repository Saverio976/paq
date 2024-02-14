#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/ajeetdsouza/zoxide/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/zoxide.tar.gz "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-${version}-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/zoxide.tar.gz -C /tmp
