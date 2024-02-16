# Packages

## Create new package

When the container is ran, a volume is mapped to /out for you to put the
distributed file in it.

```Dockerfile
# at the end of the dockerfile
CMD mv path/to/files/distributed/* /out
```

`/out` at the end must have a file named `metadata.toml` containing this:

```toml
author = "Foo"
description = "Baz bar project"
homepage = "exemple.com"
license = "Apache-2.0"
binaries = [ # this binaries will be symlinked in the PATH of users
    "bin/baz", # relative to the folder /out
    "bar" # relative to the folder /out
]
name = "baz-bar" # must be the same as the directory name in this repo
                 # i.e.: package `baz-bar` must have its directory in
                 # `packages/baz-bar`.
version = "X.X.X.x"
deps = [
    "anotherpackagename",
    "packagename"
]
chmod = [
    {path = "libs/baz", mode = "binary"} # `path` is relative to /out
                                         # `mode` can be `binary`
]
```

## paq-packages.toml

It is used to know which packages are ok to download and the url to use

It contain a top level empty `[paq]`

```toml
[paq]
```

And for each package

*`xxx` is the name of the package*
*`yyy` is the version*
*`www` is the url to download the package*

```toml
[packages.xxx]
version = "yyy"
download_url = "www"
content_type = "application/zip"
```
