#!/bin/bash

endpoint="https://www.torproject.org"
file=$(curl -sfL "$endpoint/download/" | grep downloadLink | grep tor-browser-linux-x86_64 | head -n 1 | awk -F 'href' '{print $2}' | cut -d'"' -f2)
curl -Lo /tmp/tor-browser-linux.tar.xz "$endpoint/$file"
version=$(echo $file | cut -d'/' -f4)
tar xf /tmp/tor-browser-linux.tar.xz -C /tmp
curl -Lo /tmp/LICENSE.html 'https://gitlab.torproject.org/tpo/applications/tor-browser/-/raw/tor-browser-115.11.0esr-13.5-1/toolkit/content/license.html'
curl -Lo /tmp/README.md 'https://gitlab.torproject.org/tpo/applications/tor-browser/-/raw/tor-browser-115.11.0esr-13.5-1/README.md?ref_type=heads'
echo "$version" > /tmp/version
