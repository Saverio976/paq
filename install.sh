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

get_python() {
    if command -v python3; then
        echo "python3"
    elif command -v python; then
        echo "python"
    else
        return 1
    fi
    return 0
}

if command -v wget; then
    download_cmd="wget -q -O $tmp_zip $url"
elif command -v curl; then
    download_cmd="curl -s -L $url -o $tmp_zip"
elif get_python; then
    python_cmd="import urllib.request; res = urllib.request.urlopen('$url'); with open('$tmp_zip', 'wb') as f: f.write(res.read())"
    download_cmd="$(get_python) -c \"$python_cmd\""
else
    echo "Install wget or curl to download paq"
    exit 1
fi

$download_cmd
if [ "$?" -ne "0" ]; then
    echo "Failed to download paq.zip"
    exit 1
fi

if command -v unzip; then
    unzip_command="unzip -q $tmp_zip"
elif get_python; then
    python_cmd="import zipfile; with zipfile.ZipFile('$tmp_zip', 'r') as zf: zf.extractall()"
    unzip_command="$(get_python) -c \"$python_cmd\""
else
    echo "Install unzip to extract paq.zip"
    exit 1
fi

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
./bin/paq add-repo "https://github.com/Saverio976/paq/releases/latest/download/paq-packages.toml"
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
