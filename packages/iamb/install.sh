#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/ulyssa/iamb/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/iamb.tar.gz "https://github.com/ulyssa/iamb/releases/latest/download/iamb-${version}-x86_64-unknown-linux-musl.tgz"
tar xf /tmp/iamb.tar.gz -C /tmp
mv "/tmp/iamb-${version}-x86_64-unknown-linux-musl" /tmp/iamb
find /tmp/iamb -type f -exec chmod a+rwx {} \;
