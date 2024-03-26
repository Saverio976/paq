# paq

## Usage

```txt
Usage: paq [flags] [commands]

WIP side project package manager

Flags:
  -help               Prints help information.
  -version            Prints version information.
  -man                Prints the auto-generated manpage.

Commands:
  install             install a package from a package list
  uninstall           uninstall a package
  update              update all list of packages
  upgrade             upgrade all packages
  config              config management tools
  help                Prints help information.
  version             Prints version information.
  man                 Prints the auto-generated manpage.
```

```bash
paq install <repo> <package>
paq update
paq upgrade
paq uninstall <package>
```

list of available packages: <https://github.com/Saverio976/paq/issues/2>

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
