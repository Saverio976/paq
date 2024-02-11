import dataclasses
import os
import tomllib
import toml
import shutil
from typing import List
from xdg_base_dirs import xdg_config_home
from paq import remove_symlinks


@dataclasses.dataclass
class ConfRemove:
    install_dir: str
    bin_dir: str


@dataclasses.dataclass
class InstalledPackage:
    name: str

    @staticmethod
    def get_path_config() -> str:
        return os.path.join(xdg_config_home(), "paq", "installed.toml")

    @staticmethod
    def get_all_packages() -> List["InstalledPackage"]:
        try:
            with open(InstalledPackage.get_path_config(), "rb") as f:
                datas = tomllib.load(f)
        except FileNotFoundError:
            return []

        packages = []
        for key, _ in datas.items():
            packages.append(InstalledPackage(key))

        return packages

    @staticmethod
    def add_package(name: str):
        try:
            with open(InstalledPackage.get_path_config(), "rb") as f:
                datas = tomllib.load(f)
        except FileNotFoundError:
            datas = {}

        if name in datas:
            return

        datas[name] = {}
        with open(InstalledPackage.get_path_config(), "w") as f:
            toml.dump(datas, f)

    def remove_package(self, conf: ConfRemove):
        # remove all packages if uninstall paq
        if self.name == "paq":
            for package in self.get_all_packages():
                if package.name == "paq":
                    continue
                package.remove_package(conf)

        try:
            with open(InstalledPackage.get_path_config(), "rb") as f:
                datas = tomllib.load(f)
        except FileNotFoundError:
            return

        if self.name not in datas:
            return

        print(f"Removing package: {self.name}")

        install_dir = os.path.join(conf.install_dir, self.name)
        remove_symlinks(conf.bin_dir, install_dir)
        shutil.rmtree(install_dir)

        datas.pop(self.name)
        with open(InstalledPackage.get_path_config(), "w") as f:
            toml.dump(datas, f)
        print(f"Removed package: {self.name}")
