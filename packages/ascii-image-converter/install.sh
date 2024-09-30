#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/TheZoraiz/ascii-image-converter/releases/latest' | cut -d'/' -f8)
if [[ "${version}" == "v"* ]]; then
    version=${version:1}
fi
curl -Lo /tmp/ascii-image-converter.tar.gz "https://github.com/TheZoraiz/ascii-image-converter/releases/latest/download/ascii-image-converter_Linux_amd64_64bit.tar.gz"
tar xf /tmp/ascii-image-converter.tar.gz -C /tmp
mv /tmp/ascii-image-converter_Linux_amd64_64bit /tmp/ascii-image-converter
