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
