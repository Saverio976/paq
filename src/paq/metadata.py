import dataclasses
from typing import List


@dataclasses.dataclass
class MetaData:
    author: str
    description: str
    homepage: str
    license: str
    binaries: List[str]
    version: str
    name: str

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
        return MetaData(
            author=d["author"],
            description=d["description"],
            homepage=d["homepage"],
            license=d["license"],
            binaries=d["binaries"],
            version=d["version"],
            name=d["name"],
        )
