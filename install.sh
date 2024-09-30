#!/bin/bash

working_dir=$(pwd)

in_created_dir=1
if command -v mktemp; then
    cd $(mktemp -d)
elif [ -d /tmp ] && command -v mkdir; then
    cd /tmp
    mkdir paq-tmp
    cd paq-tmp
elif command -v mkdir; then
    mkdir paq-tmp
else
    in_created_dir=0
fi

tmp_zip="paq-tmp.zip"
url="https://github.com/Saverio976/paq/releases/latest/download/paq.zip"
download_cmd=""
unzip_command=""

if command -v wget; then
    download_cmd="wget -q -O $tmp_zip $url"
elif command -v curl; then
    download_cmd="curl -s -L $url -o $tmp_zip"
else
    echo "Install wget or curl to download paq"
    exit 1
fi

echo "$download_cmd"
$download_cmd
if [ "$?" -ne "0" ]; then
    echo "Failed to download paq.zip"
    exit 1
fi

if command -v unzip; then
    unzip_command="unzip -q $tmp_zip"
else
    echo "Install unzip to extract paq.zip"
    exit 1
fi

echo 'echo *'
echo *

echo "$unzip_command"
$unzip_command
if [ "$?" -ne "0" ]; then
    echo "Failed to extract paq.zip"
    exit 1
fi

if [ "$BIN_DIR" != "" ]; then
    ./bin/paq config set bin_dir "$BIN_DIR"
fi
if [ "$INSTALL_DIR" != "" ]; then
    ./bin/paq config set install_dir "$INSTALL_DIR"
fi
./bin/paq config add-repo "https://github.com/Saverio976/paq/releases/latest/download/paq-packages.toml"
./bin/paq install paq paq

# clean
rm $tmp_zip
if [ -f "LICENSE" ]; then
    rm LICENSE
fi
if [ -f "README.md" ]; then
    rm README.md
fi
if [ -f "metadata.toml" ]; then
    rm metadata.toml
fi
if [ -f "bin/paq" ]; then
    rm bin/paq
fi
if [ "$in_created_dir" -eq "1" ]; then
    to_rm=$(pwd)
    cd $working_dir
    rm -rf $to_rm
fi
