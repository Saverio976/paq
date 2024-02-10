from typing import Iterable, List, Optional
import shutil
from pathlib import Path
import dataclasses
import zipfile
import requests
import tomllib
import toml
from sys import platform
import stat
import argparse
import tempfile
from xdg_base_dirs import xdg_data_home, xdg_config_home
import os
from ghapi.all import GhApi


def get_default_bin_dir() -> str:
    dirs = os.environ["PATH"].split(":")
    for dirr in dirs:
        if not os.path.isdir(dirr):
            continue
        if os.access(dirr, os.X_OK):
            return dirr
    raise FileNotFoundError("No PATH dir writable found")

@dataclasses.dataclass
class PaqConf:
    install_dir: str
    bin_dir: str

    @staticmethod
    def get_path_config() -> str:
        return os.path.join(xdg_config_home(), "paq", "paq.toml")

    @staticmethod
    def get_conf() -> "PaqConf":
        try:
            with open(PaqConf.get_path_config(), "r") as f:
                return PaqConf.from_dict(toml.load(f))
        except FileNotFoundError:
            return PaqConf.from_dict({})


    @staticmethod
    def from_dict(d: dict):
        if install_dir := d.get("install_dir", None):
            if not isinstance(install_dir, str):
                raise ValueError("install_dir must be a string")
        else:
            install_dir = os.path.join(xdg_data_home(), "paq")
        if bin_dir := d.get("bin_dir", None):
            if not isinstance(bin_dir, str):
                raise ValueError("bin_dir must be a string")
        else:
            bin_dir = get_default_bin_dir()
        return PaqConf(install_dir, bin_dir)

    def get(self, key: str):
        if key == "install_dir":
            return self.install_dir
        if key == "bin_dir":
            return self.bin_dir
        raise KeyError(f"Unknown key: {key}")

    def set(self, key: str, value: str):
        if key == "install_dir":
            self.install_dir = value
        elif key == "bin_dir":
            self.bin_dir = value
        else:
            raise KeyError(f"Unknown key: {key}")

    def save(self):
        if not os.path.isdir(os.path.dirname(PaqConf.get_path_config())):
            os.makedirs(os.path.dirname(PaqConf.get_path_config()))
        with open(PaqConf.get_path_config(), "w") as f:
            toml.dump(dataclasses.asdict(self), f)


@dataclasses.dataclass
class Package:
    name: str
    download_url: str
    content_type: str

@dataclasses.dataclass
class MetaData:
    author: str
    description: str
    homepage: str
    license: str
    binaries: List[str]
    version: str
    name: str

    @staticmethod
    def from_dict(d: dict) -> "MetaData":
        if not isinstance(d["author"], str):
            raise ValueError("author must be a string")
        if not isinstance(d["description"], str):
            raise ValueError("description must be a string")
        if not isinstance(d["homepage"], str):
            raise ValueError("homepage must be a string")
        if not isinstance(d["license"], str):
            raise ValueError("license must be a string")
        if not isinstance(d["binaries"], list):
            raise ValueError("binaries must be a list of strings")
        for binary in d["binaries"]:
            if not isinstance(binary, str):
                raise ValueError("binaries must be a list of strings")
        if not isinstance(d["version"], str):
            raise ValueError("version must be a string")
        if not isinstance(d["name"], str):
            raise ValueError("name must be a string")
        return MetaData(
            author=d["author"],
            description=d["description"],
            homepage=d["homepage"],
            license=d["license"],
            binaries=d["binaries"],
            version=d["version"],
            name=d["name"],
        )

def get_all_packages(onwer: str = "Saverio976", repo: str = "paq") -> List[Package]:
    api = GhApi()
    packages = api.repos.get_latest_release(onwer, repo)
    def transform(package) -> Optional[Package]:
        try:
            name = Path(package["name"]).stem
        except ValueError:
            return None
        return Package(
            name=name,
            download_url=package["browser_download_url"],
            content_type=package["content_type"]
        )
    def filter_ok(packages: Iterable[Optional[Package]]) -> List[Package]:
        new_packages = []
        for package in packages:
            if package is not None:
                new_packages.append(package)
        print(f"Number of all packages: {len(new_packages)}")
        return new_packages
    return filter_ok(map(transform, packages["assets"]))

@dataclasses.dataclass
class ConfInstall:
    install_dir: str
    bin_dir: str
    update: bool

def download_package(package: Package, conf: ConfInstall):
    if package.content_type != "application/zip":
        raise ValueError(f"Unexpected content type: {package.content_type}")
    print(f"Downloading package: {package.name}")
    directory = tempfile.TemporaryDirectory()
    download_file = os.path.join(directory.name, package.name) + ".zip"
    with requests.get(package.download_url, allow_redirects=True, stream=True) as r:
        r.raise_for_status()
        with open(download_file, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    data = None
    with zipfile.ZipFile(download_file, 'r') as zipp:
        with zipp.open('metadata.toml') as meta:
            data = MetaData.from_dict(tomllib.load(meta))
    if data is None:
        raise ValueError(f"Failed to load metadata.toml from package {package.name}")
    install_dir = os.path.join(conf.install_dir, package.name)
    try:
        os.makedirs(install_dir, exist_ok=False)
    except FileExistsError:
        if not conf.update:
            raise IsADirectoryError(f"Package {package.name} already exists")
        else:
            with open(os.path.join(install_dir, "metadata.toml"), "rb") as meta:
                old_data = MetaData.from_dict(tomllib.load(meta))
            for binary in old_data.binaries:
                os.remove(os.path.join(conf.bin_dir, binary))
            os.removedirs(install_dir)
            os.makedirs(install_dir)
    with zipfile.ZipFile(download_file, 'r') as zipp:
        zipp.extractall(install_dir)
    os.remove(download_file)
    for binary in data.binaries:
        if platform in ("linux", "darwin"):
            os.chmod(os.path.join(install_dir, binary), stat.S_IXUSR | stat.S_IRUSR | stat.S_IXGRP | stat.S_IRGRP | stat.S_IXOTH)
        os.symlink(os.path.join(install_dir, binary), os.path.join(conf.bin_dir, os.path.basename(binary)))
        print(f"Symlinked {os.path.join(conf.bin_dir, binary)} -> {os.path.join(install_dir, binary)}")
    print(f"Installed package: {package.name}")

@dataclasses.dataclass
class ConfRemove:
    install_dir: str
    bin_dir: str

def remove_package(package: Package, conf: ConfRemove):
    print(f"Removing package: {package.name}")
    install_dir = os.path.join(conf.install_dir, package.name)
    with open(os.path.join(install_dir, "metadata.toml"), "rb") as meta:
        data = MetaData.from_dict(tomllib.load(meta))
    for binary in data.binaries:
        print(f"Removing symlink: {os.path.join(conf.bin_dir, os.path.basename(binary))}")
        try:
            os.remove(os.path.join(conf.bin_dir, os.path.basename(binary)))
        except FileNotFoundError:
            print("Something already deleted the symlink")
    shutil.rmtree(install_dir)
    print(f"Removed package: {package.name}")

def handler_config_get(conf: PaqConf, args: argparse.Namespace):
    print(conf.get(args.key[0]))

def handler_config_set(conf: PaqConf, args: argparse.Namespace):
    conf.set(args.key[0], args.value[0])
    conf.save()

def handler_install(conf: PaqConf, args: argparse.Namespace):
    conf.bin_dir = args.bin_dir
    conf.install_dir = args.install_dir
    packages = get_all_packages()
    pacakages_to_install = filter(lambda p: p.name in args.packages, packages)
    for package in pacakages_to_install:
        download_package(package, ConfInstall(conf.install_dir, conf.bin_dir, args.update))

def handler_update(conf: PaqConf, args: argparse.Namespace):
    args.update = True
    handler_install(conf, args)

def handler_uninstall(conf: PaqConf, args: argparse.Namespace):
    conf.bin_dir = args.bin_dir
    conf.install_dir = args.install_dir
    packages = get_all_packages()
    pacakages_to_remove = filter(lambda p: p.name in args.packages, packages)
    for package in pacakages_to_remove:
        remove_package(package, ConfRemove(conf.install_dir, conf.bin_dir))

def create_parser(conf: PaqConf) -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Install packages")
    parser.add_argument("--install-dir", nargs=1, default=conf.install_dir, type=str, action="store", help="Specify where packages will be installed")
    parser.add_argument("--bin-dir", nargs=1, default=conf.bin_dir, type=str, action="store", help="Specify where binaries will be symlinked")
    subparser = parser.add_subparsers()

    parser_config = subparser.add_parser("config")
    subparser_config = parser_config.add_subparsers()
    parser_config_get = subparser_config.add_parser("get")
    parser_config_get.set_defaults(func=handler_config_get)
    parser_config_get.add_argument("key", nargs=1, type=str, action="store", help="Key to get")
    parser_config_set = subparser_config.add_parser("set")
    parser_config_set.set_defaults(func=handler_config_set)
    parser_config_set.add_argument("key", nargs=1, type=str, action="store", help="Key to set")
    parser_config_set.add_argument("value", nargs=1, type=str, action="store", help="Value to set")

    parser_install = subparser.add_parser("install")
    parser_install.set_defaults(func=handler_install)
    parser_install.add_argument("--update", action="store_true", default=False, help="Update existing packages")
    parser_install.add_argument("packages", nargs="*", type=str, action="store", help="Packages to install")

    parser_update = subparser.add_parser("update")
    parser_update.set_defaults(func=handler_update)
    parser_update.add_argument("packages", nargs="*", type=str, action="store", help="Packages to install")

    parser_uninstall = subparser.add_parser("uninstall")
    parser_uninstall.set_defaults(func=handler_uninstall)
    parser_uninstall.add_argument("packages", nargs="*", type=str, action="store", help="Packages to install")

    return parser

def main():
    conf = PaqConf.get_conf()
    parser = create_parser(conf)
    args = parser.parse_args()
    args.func(conf, args)

main()
