#!/bin/bash

#version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/atuinsh/atuin/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/atuin.tar.gz "https://github.com/atuinsh/atuin/releases/latest/download/atuin-x86_64-unknown-linux-musl.tar.gz"
tar xf /tmp/atuin.tar.gz -C /tmp
mv "/tmp/atuin-x86_64-unknown-linux-musl" /tmp/atuin
