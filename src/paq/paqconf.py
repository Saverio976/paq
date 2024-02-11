import dataclasses
from xdg_base_dirs import xdg_config_home, xdg_data_home
import toml
import os


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
