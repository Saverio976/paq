#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/terrastruct/d2/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/d2.tar.gz "https://github.com/terrastruct/d2/releases/latest/download/d2-${version}-linux-amd64.tar.gz"
tar xf /tmp/d2.tar.gz -C /tmp
mv "/tmp/d2-${version}" /tmp/d2
