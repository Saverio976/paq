import dataclasses
from typing import List
import stat
import sys
import os
import tomllib


@dataclasses.dataclass
class Chmod:
    path: str
    mode: str


@dataclasses.dataclass
class MetaData:
    author: str
    description: str
    homepage: str
    license: str
    binaries: List[str]
    version: str
    name: str
    deps: List[str]
    chmod: List[Chmod]

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
        if not isinstance(d["deps"], list):
            raise ValueError("deps must be a list of strings")
        for dep in d["deps"]:
            if not isinstance(dep, str):
                raise ValueError("deps must be a list of strings")
        if not isinstance(d["chmod"], list):
            raise ValueError(
                'chmod must be list of {path = "string", mode = "string"}'
            )
        for file in d["chmod"]:
            if not isinstance(file, dict):
                raise ValueError(
                    'chmod must be list of {path = "string", mode = "string"}'
                )
            for key, value in file.items():
                if key not in ("path", "mode"):
                    raise ValueError(
                        'chmod must be list of {path = "", mode = ""}'
                    )
                ok = ("binary",)
                if key == "mode" and value not in ok:
                    message = (
                        "chmod must be list of "
                        + '{path = "string", mode = "string"} '
                        + "and mode must be one of "
                        + f"{ok}"
                    )
                    raise ValueError(message)
                if key == "path" and not isinstance(value, str):
                    message = (
                        "chmod must be list of "
                        + '{path = "string", mode = "string"} '
                        + "and path must be relative to package"
                    )
                    raise ValueError(message)
        return MetaData(
            author=d["author"],
            description=d["description"],
            homepage=d["homepage"],
            license=d["license"],
            binaries=d["binaries"],
            version=d["version"],
            name=d["name"],
            deps=d["deps"],
            chmod=list(
                map(
                    lambda x: Chmod(path=x["path"], mode=x["mode"]), d["chmod"]
                )
            ),
        )


def remove_symlinks(bin_dir: str, install_dir_package: str):
    with open(
        os.path.join(install_dir_package, "metadata.toml"), "rb"
    ) as meta:
        data = MetaData.from_dict(tomllib.load(meta))
    for binary in data.binaries:
        try:
            os.remove(os.path.join(bin_dir, os.path.basename(binary)))
        except FileNotFoundError:
            pass


def add_symlinks(bin_dir: str, install_dir_package: str):
    with open(
        os.path.join(install_dir_package, "metadata.toml"), "rb"
    ) as meta:
        datas = MetaData.from_dict(tomllib.load(meta))
    for binary in datas.binaries:
        if sys.platform in ("linux", "darwin"):
            os.chmod(
                os.path.join(install_dir_package, binary),
                stat.S_IXUSR
                | stat.S_IRUSR
                | stat.S_IXGRP
                | stat.S_IRGRP
                | stat.S_IXOTH,
            )
        os.symlink(
            os.path.join(install_dir_package, binary),
            os.path.join(bin_dir, os.path.basename(binary)),
        )


def apply_chmod(install_dir_package: str):
    with open(
        os.path.join(install_dir_package, "metadata.toml"), "rb"
    ) as meta:
        datas = MetaData.from_dict(tomllib.load(meta))
    for mod in datas.chmod:
        if mod.mode == "binary" and sys.platform in ("linux", "darwin"):
            os.chmod(
                os.path.join(install_dir_package, mod.path),
                stat.S_IXUSR
                | stat.S_IRUSR
                | stat.S_IXGRP
                | stat.S_IRGRP
                | stat.S_IXOTH,
            )
