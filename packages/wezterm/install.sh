#!/bin/bash

version=$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/wez/wezterm/releases/latest' | cut -d'/' -f8)
curl -Lo /tmp/wezterm-appimage "https://github.com/wez/wezterm/releases/latest/download/WezTerm-$version-Ubuntu20.04.AppImage"
chmod +x /tmp/wezterm-appimage
cd /tmp
/tmp/wezterm-appimage --appimage-extract
mv /tmp/squashfs-root /tmp/wezterm
