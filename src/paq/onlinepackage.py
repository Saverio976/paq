import dataclasses
import re
import shutil
import tempfile
from github import Github
import os
import tomllib
import zipfile
import requests
from paq import add_symlinks, remove_symlinks
from paq import MetaData
from paq.metadata import apply_chmod
from xdg_base_dirs import xdg_state_home
from hashlib import md5
from typing import List, Optional, Tuple
from rich.console import Console
from rich.progress import (
    BarColumn,
    DownloadColumn,
    Progress,
    TaskID,
    TextColumn,
    TimeRemainingColumn,
    TransferSpeedColumn,
)


def __copy_url(
    progress: Progress, task_id: TaskID, url: str, path: str
) -> None:
    """Copy data from a url to a local file."""
    progress.console.log(f"Requesting {url}")
    response = requests.get(url, stream=True, allow_redirects=True)
    response.raise_for_status()
    total_length = response.headers.get("content-length")
    if total_length is None:
        raise ValueError("Response doesn't contain content length")
    try:
        total_length = int(total_length)
    except ValueError:
        raise
    progress.update(task_id, total=total_length)
    with open(path, "wb") as dest_file:
        progress.start_task(task_id)
        for chunk in response.iter_content(chunk_size=8192):
            dest_file.write(chunk)
            progress.update(task_id, advance=len(chunk))
    progress.console.log(f"Downloaded {path}")


def fdownload_progress(console: Console, url: str, filepath: str):
    progress = Progress(
        TextColumn("[bold blue]{task.fields[filename]}", justify="right"),
        BarColumn(bar_width=None),
        "[progress.percentage]{task.percentage:>3.1f}%",
        "•",
        DownloadColumn(),
        "•",
        TransferSpeedColumn(),
        "•",
        TimeRemainingColumn(),
        console=console,
    )
    with progress:
        task_id = progress.add_task("download", filename=filepath, start=False)
        __copy_url(progress, task_id, url, filepath)


@dataclasses.dataclass
class ConfInstall:
    install_dir: str
    bin_dir: str
    update: bool
    no_update: bool


@dataclasses.dataclass
class OnlinePackage:
    name: str
    download_url: str
    content_type: str
    version: str
    checksum: str
    meta: Optional[MetaData] = None

    @staticmethod
    def get_paq_packages() -> str:
        p = os.path.join(xdg_state_home(), "paq", "paq-packages.toml")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        return p

    @staticmethod
    def get_all_packages(
        owner: str = "Saverio976",
        repo: str = "paq",
        queries: List[str] = [],
        latest_paq: Optional[str] = None,
    ) -> List["OnlinePackage"]:
        recompiled: List[re.Pattern] = []
        for query in queries:
            recompiled.append(re.compile(query))

        if latest_paq is None:
            g = Github()
            packages = (
                g.get_repo(owner + "/" + repo)
                .get_latest_release()
                .get_assets()
            )

            def is_packages_file(package) -> bool:
                return package.name == "paq-packages.toml"

            package = list(filter(is_packages_file, packages))[0]

            with open(OnlinePackage.get_paq_packages(), "wb") as f:
                with requests.get(
                    package.browser_download_url,
                    allow_redirects=True,
                    stream=True,
                ) as r:
                    r.raise_for_status()
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

        with open(OnlinePackage.get_paq_packages(), "rb") as f:
            datas = tomllib.load(f)

        def transform(name, package: dict) -> Optional[OnlinePackage]:
            is_ok = True
            if len(recompiled) > 0:
                is_ok = False
                for com in recompiled:
                    if com.match(name) is not None:
                        is_ok = True
                        break
            if not is_ok:
                return None

            if (
                package.get("content_type", None) != "application/zip"
                or package.get("download_url", None) is None
                or package.get("version", None) is None
                or package.get("checksum", None) is None
            ):
                return None
            if (
                not isinstance(package["version"], str)
                or not isinstance(package["download_url"], str)
                or not isinstance(package["checksum"], str)
            ):
                return None

            return OnlinePackage(
                name=name,
                download_url=package["download_url"],
                content_type=package["content_type"],
                checksum=package["checksum"],
                version=package["version"],
            )

        new_packages = []
        for key, value in datas.get("packages", {}).items():
            pack = transform(key, value)
            if pack is not None:
                new_packages.append(pack)

        return new_packages

    def __checksum(self, filename) -> bool:
        hash = md5()
        with open(filename, "rb") as f:
            for chunk in iter(lambda: f.read(128 * hash.block_size), b""):
                hash.update(chunk)
        return hash.hexdigest() == self.checksum

    def __download_package(
        self, console: Console
    ) -> Tuple[str, tempfile.TemporaryDirectory]:
        if self.content_type != "application/zip":
            raise ValueError(f"Unexpected content type: {self.content_type}")
        tmpdir = tempfile.TemporaryDirectory(prefix="paq", suffix=self.name)
        download_target = os.path.join(tmpdir.name, self.name) + ".zip"
        fdownload_progress(console, self.download_url, download_target)
        # with open(download_target, "wb") as f:
        #     with requests.get(
        #         self.download_url, allow_redirects=True, stream=True
        #     ) as r:
        #         r.raise_for_status()
        #         for chunk in r.iter_content(chunk_size=8192):
        #             f.write(chunk)
        if self.__checksum(download_target) is False:
            message = (
                "Downloaded package zip does not correspond "
                + "for package "
                + f"{self.name}"
            )
            raise ValueError(message)
        return download_target, tmpdir

    def get_metadata(
        self, console: Console, download_target: Optional[str] = None
    ) -> MetaData:
        if self.meta is not None:
            return self.meta
        tmpdir: Optional[tempfile.TemporaryDirectory] = None
        if download_target is None:
            download_target, tmpdir = self.__download_package(console)
        with zipfile.ZipFile(download_target, "r") as zipp:
            with zipp.open("metadata.toml") as meta:
                self.meta = MetaData.from_dict(tomllib.load(meta))
        if tmpdir is not None:
            tmpdir.cleanup()
        return self.meta

    def install(self, console: Console, conf: ConfInstall):
        print(f"Installing package: {self.name}")
        download_target, tmpdir = self.__download_package(console)
        datas = self.get_metadata(console, download_target)
        if len(datas.deps) > 0:
            all_packages = OnlinePackage.get_all_packages(
                latest_paq=OnlinePackage.get_paq_packages()
            )
            conf_copy = ConfInstall(**dataclasses.asdict(conf), no_update=True)
            for pak in all_packages:
                if pak.name in datas.deps:
                    pak.install(console, conf_copy)
        install_dir = os.path.join(conf.install_dir, self.name)
        try:
            os.makedirs(install_dir, exist_ok=False)
        except FileExistsError:
            if conf.no_update:
                return
            if not conf.update:
                raise IsADirectoryError(f"Package {self.name} already exists")
            else:
                remove_symlinks(conf.bin_dir, install_dir)
                shutil.rmtree(install_dir)
                os.makedirs(install_dir)
        with zipfile.ZipFile(download_target, "r") as zipp:
            zipp.extractall(install_dir)
        os.remove(download_target)
        apply_chmod(install_dir)
        add_symlinks(conf.bin_dir, install_dir)
        print(f"Installed package: {self.name}")
        tmpdir.cleanup()
