#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/streamlink/streamlink-appimage/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/streamlink-appimage "https://github.com/streamlink/streamlink-appimage/releases/latest/download/streamlink-${version}-cp312-cp312-manylinux2014_x86_64.AppImage"
chmod +x /tmp/streamlink-appimage
cd /tmp
/tmp/streamlink-appimage --appimage-extract
mv /tmp/squashfs-root /tmp/streamlink
mv /tmp/streamlink/AppRun /tmp/streamlink/streamlink
