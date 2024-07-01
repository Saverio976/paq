#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/regen100/lfs-dal/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/lfs-dal.tar.gz "https://github.com/regen100/lfs-dal/releases/latest/download/lfs-dal-${version}-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/lfs-dal.tar.gz -C /tmp
