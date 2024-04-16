#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/ImageMagick/ImageMagick/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/magick-appimage "https://github.com/ImageMagick/ImageMagick/releases/latest/download/ImageMagick--gcc-x86_64.AppImage"
chmod +x /tmp/magick-appimage
cd /tmp
/tmp/magick-appimage --appimage-extract
mv /tmp/squashfs-root /tmp/magick
