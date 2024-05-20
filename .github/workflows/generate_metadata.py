import tomllib
import os
import requests
import zipfile
import pathlib
import re
from hashlib import md5

PACKAGES_FILE = "/tmp/paq-packages.toml"
with open(PACKAGES_FILE, "w") as f:
    f.write("name = \"paq\"\n\n")

LOG_FILE = "/tmp/paq-packages.log"
with open(LOG_FILE, "w") as f:
    f.write("")


def log_error(log_to_file, message):
    if log_to_file:
        with open(LOG_FILE, "a") as f:
            f.write(message + "\n")
        print(message)
    else:
        print(message)


def md5sum(filename):
    hash = md5()
    with open(filename, "rb") as f:
        for chunk in iter(lambda: f.read(128 * hash.block_size), b""):
            hash.update(chunk)
    return hash.hexdigest()


reg_expr = r"[a-zA-Z0-9\-_]{2,}"
reg = re.compile(reg_expr)


def verify_metadata(data, package, log_to_file):
    if "author" not in data or not isinstance(data["author"], str):
        log_error(log_to_file, f"- [3] {package}:: author must be string")
        return False
    if "description" not in data or not isinstance(data["description"], str):
        log_error(log_to_file, f"- [4] {package}:: description must be string")
        return False
    if "homepage" not in data or not isinstance(data["homepage"], str):
        log_error(log_to_file, f"- [5] {package}:: homepage must be string")
        return False
    if "license" not in data or not isinstance(data["license"], str):
        log_error(log_to_file, f"- [6] {package}:: license must be string")
        return False
    if "binaries" not in data or not isinstance(data["binaries"], list):
        log_error(log_to_file, f"- [7] {package}:: binaries must be list")
        return False
    for binary in data["binaries"]:
        if not isinstance(binary, str):
            log_error(
                log_to_file, f"- [8] {package}:: binaries must be list of string"
            )
            return False
    if "name" not in data or not isinstance(data["name"], str):
        log_error(log_to_file, f"- [9] {package}:: name must be string")
        return False
    if "version" not in data or not isinstance(data["version"], str):
        log_error(log_to_file, f"- [10] {package}:: version must be string")
        return False
    if "deps" not in data or not isinstance(data["deps"], list):
        log_error(log_to_file, f"- [11] {package}:: deps must be list")
        return False
    for dep in data["deps"]:
        if not isinstance(dep, str):
            log_error(
                log_to_file, f"- [12] {package}:: deps must be list of string"
            )
            return False
    if "chmod" not in data or not isinstance(data["chmod"], list):
        log_error(log_to_file, f"- [13] {package}:: chmod must be list")
        return False
    for mod in data["chmod"]:
        if not isinstance(mod, dict) or len(mod.keys()) != 2:
            log_error(
                log_to_file,
                f"- [14] {package}:: chmod must be list of dict"
                + ' {path = "string", mode = "string"}',
            )
            return False
        for key, value in mod.items():
            ok_key = ("path", "mode")
            if key not in ok_key:
                log_error(
                    log_to_file,
                    f"- [15] {package}:: chmod must be list of dict with keys: {ok_key}",
                )
                return False
            ok_mode = ("binary",)
            if key == "mode" and value not in ok_mode:
                log_error(
                    log_to_file,
                    f"- [16] {package}:: chmod mode must be in {ok_mode}",
                )
                return False
            if key == "path" and not isinstance(value, str):
                log_error(
                    log_to_file, f"- [17] {package}:: chmod path must be string"
                )
    match = reg.match(data["name"])
    if match is None:
        log_error(
            log_to_file,
            f"- [18] {package}:: name must match regular expression: {reg_expr}",
        )
        return False
    if match.start() != 0 or match.end() != len(data["name"]):
        log_error(
            log_to_file,
            f"- [19] {package}:: name must match regular expression: {reg_expr}",
        )
        return False
    return True


def process_package_local(file_metadata):
    with open(file_metadata, "rb") as f:
        datas = tomllib.load(f)
    return verify_metadata(datas, file_metadata, False)


def process_packages():
    from github import Github

    g = Github()
    packages = g.get_repo("Saverio976/paq").get_latest_release().get_assets()

    for package in packages:
        if package.name == "paq-packages.toml":
            continue
        print(package.name, "...")
        target_dowload_zip = os.path.join("/tmp", package.name) + ".zip"
        with open(target_dowload_zip, "wb") as f:
            with requests.get(
                package.browser_download_url, allow_redirects=True, stream=True
            ) as r:
                r.raise_for_status()
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        try:
            with zipfile.ZipFile(target_dowload_zip, "r") as zipp:
                with zipp.open("metadata.toml") as meta:
                    data = tomllib.load(meta)
        except Exception as esc:
            log_error(True, f"Error in package [1] {package.name}: {esc}")
            continue
        if not verify_metadata(data, package.name, True):
            continue
        if data["name"] != pathlib.Path(package.name).stem:
            log_error(
                True,
                f"Error in package [2] {package.name}: name must be same as metadata and folder",
            )
            continue
        with open(PACKAGES_FILE, "a") as f:
            f.write(f"[packages.{data['name']}]\n")
            f.write(f"version = \"{data['version']}\"\n")
            f.write(f'download_url = "{package.browser_download_url}"\n')
            f.write(f'content_type = "{package.content_type}"\n')
            f.write(f'checksum = "{md5sum(target_dowload_zip)}"\n')
        print(f"Done: {data['name']}")


if __name__ == "__main__":
    import sys

    if len(sys.argv) == 2:
        if process_package_local(sys.argv[1]) is False:
            exit(1)
    else:
        process_packages()
