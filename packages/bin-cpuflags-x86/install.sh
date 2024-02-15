#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/HanabishiRecca/bin-cpuflags-x86/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/bin-cpuflags-x86.tar.gz "https://github.com/HanabishiRecca/bin-cpuflags-x86/releases/latest/download/bin-cpuflags-x86-${version}-linux-x86_64.tar.xz"
tar xf /tmp/bin-cpuflags-x86.tar.gz -C /tmp
