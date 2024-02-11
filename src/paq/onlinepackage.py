import dataclasses
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
    meta_download_url: str = ""
    meta: Optional[MetaData] = None

    @staticmethod
    def get_all_packages(
        owner: str = "Saverio976", repo: str = "paq"
    ) -> List["OnlinePackage"]:
        g = Github()
        packages = g.get_repo(owner + "/" + repo).get_latest_release().get_assets()

        def transform(package) -> Optional[OnlinePackage]:
            try:
                name = Path(package.name).stem
            except ValueError:
                return None
            return OnlinePackage(
                name=name,
                download_url=package.browser_download_url,
                content_type=package.content_type,
            )

        def filter_ok(
            packages: Iterable[Optional[OnlinePackage]],
        ) -> List[OnlinePackage]:
            new_packages = []
            for package in packages:
                if package is not None:
                    new_packages.append(package)
            print(f"Number of all packages: {len(new_packages)}")
            return new_packages

        return filter_ok(map(transform, packages))

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

    def get_metadata(self) -> MetaData:
        if self.meta is not None:
            return self.meta
        download_target, tmpdir = self.__download_package()
        with zipfile.ZipFile(download_target, "r") as zipp:
            with zipp.open("metadata.toml") as meta:
                self.meta = MetaData.from_dict(tomllib.load(meta))
        tmpdir.cleanup()
        return self.meta

    def install(self, conf: ConfInstall):
        download_target, tmpdir = self.__download_package()
        data = self.get_metadata()
        install_dir = os.path.join(conf.install_dir, self.name)
        try:
            os.makedirs(install_dir, exist_ok=False)
        except FileExistsError:
            if not conf.update:
                raise IsADirectoryError(f"Package {self.name} already exists")
            else:
                with open(os.path.join(install_dir, "metadata.toml"), "rb") as meta:
                    old_data = MetaData.from_dict(tomllib.load(meta))
                for binary in old_data.binaries:
                    os.remove(os.path.join(conf.bin_dir, binary))
                os.removedirs(install_dir)
                os.makedirs(install_dir)
        with zipfile.ZipFile(download_target, "r") as zipp:
            zipp.extractall(install_dir)
        os.remove(download_target)
        for binary in data.binaries:
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
                os.path.join(conf.bin_dir, os.path.basename(binary)),
            )
            print(
                f"Symlinked {os.path.join(conf.bin_dir, binary)} -> {os.path.join(install_dir, binary)}"
            )
        print(f"Installed package: {self.name}")
        tmpdir.cleanup()

    def uninstall(self, conf: ConfRemove):
        print(f"Removing package: {self.name}")
        install_dir = os.path.join(conf.install_dir, self.name)
        with open(os.path.join(install_dir, "metadata.toml"), "rb") as meta:
            data = MetaData.from_dict(tomllib.load(meta))
        for binary in data.binaries:
            print(
                f"Removing symlink: {os.path.join(conf.bin_dir, os.path.basename(binary))}"
            )
            try:
                os.remove(os.path.join(conf.bin_dir, os.path.basename(binary)))
            except FileNotFoundError:
                print("Something already deleted the symlink")
        shutil.rmtree(install_dir)
        print(f"Removed package: {self.name}")
