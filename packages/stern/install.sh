#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/stern/stern/releases/latest' | cut -d'/' -f8)
version=${version:1}
curl -Lo /tmp/stern.tar.gz "https://github.com/stern/stern/releases/latest/download/stern_${version}_linux_amd64.tar.gz"
tar xf /tmp/stern.tar.gz -C /tmp
curl -Lo /tmp/README.md 'https://raw.githubusercontent.com/stern/stern/master/README.md'
