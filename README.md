# paq

## Usage

```python
usage: paq [-h] [--install-dir INSTALL_DIR] [--bin-dir BIN_DIR] {config,install,update,uninstall,search} ...

Install packages

positional arguments:
  {config,install,update,uninstall,search}

options:
  -h, --help            show this help message and exit
  --install-dir INSTALL_DIR
                        Specify where packages will be installed
  --bin-dir BIN_DIR     Specify where binaries will be symlinked
```

```bash
paq install <package>
paq uninstall <package>
paq search '.' # list all packages
paq search 'p.t|l' # regex search
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
