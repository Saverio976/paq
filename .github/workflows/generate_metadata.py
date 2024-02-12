import tomllib
import os
import requests
import zipfile
import pathlib
from github import Github

g = Github()

PACKAGES_FILE = "/tmp/paq-packages.toml"
with open(PACKAGES_FILE, "w") as f:
    f.write("[paq]\n\n")

LOG_FILE = "/tmp/paq-packages.log"
with open(LOG_FILE, "w") as f:
    f.write("")

packages = g.get_repo("Saverio976/paq").get_latest_release().get_assets()


def log_error(message):
    with open(LOG_FILE, "a") as f:
        f.write(message + "\n")


def verify_metadata(data):
    if "author" not in data or not isinstance(data["author"], str):
        return False
    if "description" not in data or not isinstance(data["description"], str):
        return False
    if "homepage" not in data or not isinstance(data["homepage"], str):
        return False
    if "license" not in data or not isinstance(data["license"], str):
        return False
    if "binaries" not in data or not isinstance(data["binaries"], list):
        return False
    for binary in data["binaries"]:
        if not isinstance(binary, str):
            return False
    if "name" not in data or not isinstance(data["name"], str):
        return False
    if "version" not in data or not isinstance(data["version"], str):
        return False
    return True


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
        log_error(f"Error in package {package.name}: {esc}")
        continue
    if not verify_metadata(data):
        log_error(f"Error in package {package.name}: invalid metadata")
        continue
    if data["name"] != pathlib.Path(package.name).stem:
        log_error(f"Error in package {package.name}: invalid name")
        continue
    with open(PACKAGES_FILE, "a") as f:
        f.write(f"[packages.{data['name']}]\n")
        f.write(f"version = \"{data['version']}\"\n")
        f.write(f'download_url = "{package.browser_download_url}"\n')
        f.write(f'content_type = "{package.content_type}"\n')
    print(f"Done: {data['name']}")
