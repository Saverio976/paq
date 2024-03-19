import dataclasses
import os
import tomllib
import toml
import shutil
from typing import List, Optional
from xdg_base_dirs import xdg_config_home
from paq import remove_symlinks, MetaData
from rich.live import Live
from rich.spinner import Spinner


@dataclasses.dataclass
class ConfRemove:
    install_dir: str
    bin_dir: str


@dataclasses.dataclass
class InstalledPackage:
    name: str
    meta: Optional[MetaData] = None

    @staticmethod
    def get_path_config() -> str:
        return os.path.join(xdg_config_home(), "paq", "installed.toml")

    @staticmethod
    def get_all_packages(queries: List[str] = []) -> List["InstalledPackage"]:
        try:
            with open(InstalledPackage.get_path_config(), "rb") as f:
                datas = tomllib.load(f)
        except FileNotFoundError:
            return []

        packages = []
        default_found = True if len(queries) == 0 else False
        for key, _ in datas.items():
            found = default_found
            for query in queries:
                if query in key:
                    found = True
                    break
            if found:
                packages.append(InstalledPackage(key))

        return packages

    @staticmethod
    def add_package(name: str) -> "InstalledPackage":
        try:
            with open(InstalledPackage.get_path_config(), "rb") as f:
                datas = tomllib.load(f)
        except FileNotFoundError:
            datas = {}

        if name in datas:
            InstalledPackage(name)

        datas[name] = {}
        with open(InstalledPackage.get_path_config(), "w") as f:
            toml.dump(datas, f)
        return InstalledPackage(name)

    def remove_package(self, console, conf: ConfRemove):
        # remove all packages if uninstall paq
        if self.name == "paq":
            for package in self.get_all_packages():
                if package.name == "paq":
                    continue
                package.remove_package(console, conf)

        try:
            with open(InstalledPackage.get_path_config(), "rb") as f:
                datas = tomllib.load(f)
        except FileNotFoundError:
            return

        if self.name not in datas:
            return

        live = Live(
            Spinner("simpleDotsScrolling"),
            console=console,
            refresh_per_second=20,
        )
        with live:
            live.console.log(f"Removing {self.name}")

            install_dir = os.path.join(conf.install_dir, self.name)
            remove_symlinks(conf.bin_dir, install_dir)
            shutil.rmtree(install_dir, ignore_errors=True)

            datas.pop(self.name)
            with open(InstalledPackage.get_path_config(), "w") as f:
                toml.dump(datas, f)

            live.console.log(f"Removed {self.name}")

    def get_metadata(self, conf: ConfRemove) -> MetaData:
        if self.meta is not None:
            return self.meta
        with open(
            os.path.join(conf.install_dir, self.name, "metadata.toml"), "rb"
        ) as f:
            datas = tomllib.load(f)
        self.meta = MetaData.from_dict(datas)
        return self.meta
