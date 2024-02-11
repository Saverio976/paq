import dataclasses
import re
import tempfile
from typing import List, Optional, Iterable, Tuple
from github import Github
from pathlib import Path
import os
import tomllib
import zipfile
import sys
import stat
import shutil
from paq import MetaData

import requests


@dataclasses.dataclass
class ConfInstall:
    install_dir: str
    bin_dir: str
    update: bool


@dataclasses.dataclass
class ConfRemove:
    install_dir: str
    bin_dir: str


@dataclasses.dataclass
class OnlinePackage:
    name: str
    download_url: str
    content_type: str
    version: str
    meta: Optional[MetaData] = None

    @staticmethod
    def get_all_packages(
        owner: str = "Saverio976", repo: str = "paq", query: Optional[str] = None
    ) -> List["OnlinePackage"]:
        recompiled: Optional[re.Pattern] = None
        if query is not None:
            recompiled = re.compile(query)
        g = Github()
        packages = g.get_repo(owner + "/" + repo).get_latest_release().get_assets()

        def is_packages_file(package) -> bool:
            return package.name == "paq-packages.toml"

        package = list(filter(is_packages_file, packages))[0]

        with open("/tmp/paq-packages.toml", "wb") as f:
            with requests.get(package.browser_download_url, allow_redirects=True, stream=True) as r:
                r.raise_for_status()
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        with open("/tmp/paq-packages.toml", "rb") as f:
            datas = tomllib.load(f)

        def transform(name, package: dict) -> Optional[OnlinePackage]:
            if recompiled is not None:
                if recompiled.match(name) is None:
                    return None
            if package.get("content_type", None) != "application/zip" or package.get("download_url", None) is None or package.get("version", None) is None:
                return None
            if not isinstance(package["version"], str) or not isinstance(package["download_url"], str):
                return None

            return OnlinePackage(
                name=name,
                download_url=package["download_url"],
                content_type=package["content_type"],
                version=package["version"],
            )

        new_packages = []
        for key, value in datas.get("packages", {}).items():
            pack = transform(key, value)
            if pack is not None:
                new_packages.append(pack)
        print(f"Found {len(new_packages)} packages")
        print(new_packages)

        return new_packages

    def __download_package(self) -> Tuple[str, tempfile.TemporaryDirectory]:
        if self.content_type != "application/zip":
            raise ValueError(f"Unexpected content type: {self.content_type}")
        tmpdir = tempfile.TemporaryDirectory(prefix="paq", suffix=self.name)
        download_target = os.path.join(tmpdir.name, self.name) + ".zip"
        with open(download_target, "wb") as f:
            with requests.get(self.download_url, allow_redirects=True, stream=True) as r:
                r.raise_for_status()
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        return download_target, tmpdir

    def get_metadata(self, download_target: Optional[str] = None) -> MetaData:
        if self.meta is not None:
            return self.meta
        tmpdir: Optional[tempfile.TemporaryDirectory] = None
        if download_target is None:
            download_target, tmpdir = self.__download_package()
        with zipfile.ZipFile(download_target, "r") as zipp:
            with zipp.open("metadata.toml") as meta:
                self.meta = MetaData.from_dict(tomllib.load(meta))
        if tmpdir is not None:
            tmpdir.cleanup()
        return self.meta

    def install(self, conf: ConfInstall):
        download_target, tmpdir = self.__download_package()
        self.get_metadata(download_target) # add metadata to the attribute
        install_dir = os.path.join(conf.install_dir, self.name)
        try:
            os.makedirs(install_dir, exist_ok=False)
        except FileExistsError:
            if not conf.update:
                raise IsADirectoryError(f"Package {self.name} already exists")
            else:
                self.__remove_symlinks(conf.bin_dir, install_dir)
                os.removedirs(install_dir)
                os.makedirs(install_dir)
        with zipfile.ZipFile(download_target, "r") as zipp:
            zipp.extractall(install_dir)
        os.remove(download_target)
        self.__add_symlinks(conf.bin_dir, install_dir)
        print(f"Installed package: {self.name}")
        tmpdir.cleanup()

    def __remove_symlinks(self, bin_dir: str, install_dir: str):
        with open(os.path.join(install_dir, "metadata.toml"), "rb") as meta:
            data = MetaData.from_dict(tomllib.load(meta))
        for binary in data.binaries:
            try:
                os.remove(os.path.join(bin_dir, os.path.basename(binary)))
            except FileNotFoundError:
                pass

    def __add_symlinks(self, bin_dir: str, install_dir: str):
        for binary in self.get_metadata().binaries:
            if sys.platform in ("linux", "darwin"):
                os.chmod(
                    os.path.join(install_dir, binary),
                    stat.S_IXUSR
                    | stat.S_IRUSR
                    | stat.S_IXGRP
                    | stat.S_IRGRP
                    | stat.S_IXOTH,
                )
            os.symlink(
                os.path.join(install_dir, binary),
                os.path.join(bin_dir, os.path.basename(binary)),
            )

    def uninstall(self, conf: ConfRemove):
        print(f"Removing package: {self.name}")
        install_dir = os.path.join(conf.install_dir, self.name)
        self.__remove_symlinks(conf.bin_dir, install_dir)
        shutil.rmtree(install_dir)
        print(f"Removed package: {self.name}")
