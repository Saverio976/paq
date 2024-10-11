# paq

## Goal

Why the hell debian packages are so old.

Just give me the last version of neovim!!!!

## Usage

<details>
  <summary>`paq -help`</summary>

```txt
Usage: paq [flags] [commands]

WIP side project package manager
List of packages (repos) can be added with `paq config`

Flags:
  -help               Prints help information.
  -version            Prints version information.
  -man                Prints the auto-generated manpage.

Commands:
  install             install a package from a repo
  uninstall           uninstall a package
  update              update all repos
  upgrade             upgrade all packages
  search              search for a package name in all repos. If no search_term is provided, all packages will be displayed
  list                list packages installed. If no search_term is provided, all packages will be displayed
  config              config management tools
  help                Prints help information.
  version             Prints version information.
  man                 Prints the auto-generated manpage.
```

</details>

```bash
paq search <package>
paq search
paq install <repo> <package>
paq install <repo>/<package>
paq update
paq upgrade
paq list <package>
paq list
paq uninstall <package>
```

## Repository Adding Packages

- <https://github.com/Saverio976/paq-packages1> (some terminal CLI that replace basic utility)
- <https://github.com/Saverio976/paq-packages2> (some terminal CLI)
- <https://github.com/Saverio976/paq-packages3> (terminals emulator, programming languages, terminal editors, ...)

## Install

### The Hard Way

1. Dependencies

  - curl/wget
  - unzip

2. Install

  - download the [install.sh](https://raw.githubusercontent.com/Saverio976/paq/main/install.sh) script.
  - take a look at what it does.
  - run it.

  If you set the env variable `BIN_DIR`, binaries will be symlinked there.

  If you set the env variable `INSTALL_DIR`, packages will be installed there.

### The Easy Way

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

## Create a package

[README.md](./packages/README.md)
