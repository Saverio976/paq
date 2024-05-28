#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/ImageMagick/ImageMagick/releases/latest' | cut -d'/' -f8)
echo "$version"
sha=$(curl "https://api.github.com/repos/ImageMagick/ImageMagick/git/ref/tags/$version" | jq '.object.sha' | cut -d'"' -f2 | cut -c 1-7)
echo "$sha"
url="https://github.com/ImageMagick/ImageMagick/releases/latest/download/ImageMagick-$sha-gcc-x86_64.AppImage"
echo "$url"
curl -Lo /tmp/magick-appimage "$url"
chmod +x /tmp/magick-appimage
cd /tmp
/tmp/magick-appimage --appimage-extract
mv /tmp/squashfs-root /tmp/magick
