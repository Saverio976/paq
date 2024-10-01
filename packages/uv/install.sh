#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/astral-sh/uv/releases/latest' | cut -d'/' -f8)
if [[ "${version}" == "v"* ]]; then
    version=${version:1}
fi
curl -Lo /tmp/uv.tar.gz "https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/uv.tar.gz -C /tmp
mv /tmp/uv-x86_64-unknown-linux-musl /tmp/uv
