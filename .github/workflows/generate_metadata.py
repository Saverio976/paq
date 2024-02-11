import tomllib
import os
import requests
import zipfile
from github import Github

g = Github()

PACKAGES_FILE = "/tmp/paq-packages.toml"
with open(PACKAGES_FILE, "w") as f:
    f.write("[paq]\n\n")

packages = g.get_repo("Saverio976/paq").get_latest_release().get_assets()

for package in packages:
    target_dowload_zip = os.path.join("/tmp", package.name) + ".zip"
    with open(target_dowload_zip, "wb") as f:
        with requests.get(package.browser_download_url, allow_redirects=True, stream=True) as r:
            r.raise_for_status()
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    try:
        with zipfile.ZipFile(target_dowload_zip, "r") as zipp:
            with zipp.open("metadata.toml") as meta:
                data = tomllib.load(meta)
    except Exception as esc:
        print(f"Error in package {package.name}: {esc}")
        continue
    with open(PACKAGES_FILE, "a") as f:
        f.write(f"[packages.{data['name']}]\n")
        f.write(f"version = \"{data['version']}\"\n")
        f.write(f"download_url = \"{package.browser_download_url}\"\n")
