# paq

## Usage

```python
Usage: paq [-h] [--install-dir INSTALL_DIR] [--bin-dir BIN_DIR] [--version] {config,install,update,uninstall,search,list} ...

Install packages

Positional Arguments:
  {config,install,update,uninstall,search,list}

Options:
  -h, --help            show this help message and exit
  --install-dir INSTALL_DIR
                        Specify where packages will be installed
  --bin-dir BIN_DIR     Specify where binaries will be symlinked
  --version             print version of paq
```

```bash
paq install <package>
paq install # install package listed in your config file
paq update <package>
paq uninstall <package>
paq search # list available packages
paq search 'abc' # list available packages containing abc
paq list # list installed packages
paq list 'abc' # list installed packages containing abc
```

## Install

1. Dependencies

  - curl/wget
  - unzip

2. Install

  - download the [install.sh](https://raw.githubusercontent.com/Saverio976/paq/main/install.sh) script.
  - take a look at what it does.
  - run it.

  If you set the env variable `BIN_DIR`, binaries will be symlinked there.

  If you set the env variable `INSTALL_DIR`, packages will be installed there.

<details>
  <summary>One Line Script if you trust the author</summary>

```bash
curl -fsSL https://raw.githubusercontent.com/Saverio976/paq/main/install.sh | \
  BIN_DIR="$HOME/.local/bin" bash
```

</details>

## Uninstall

```
paq uninstall paq
```
