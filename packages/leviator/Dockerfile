from haskell:9.6.3

# install deps
run apt-get update -y
run apt-get install -y git

# use add to invalidate cache if sources has changed
ADD https://github.com/X-R-G-B/Leviator/archive/refs/heads/main.zip /tmp/sum
run git clone https://github.com/X-R-G-B/Leviator.git /leviator
workdir /leviator
run git checkout main
run ./scripts/InstallDepsLinux.bash

# build
run make

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp ./lvtc/lvtc-exe /tmp/out/bin/lvtc
run cp ./lvtrun/lvtrun-exe /tmp/out/bin/lvtrun
run cp ./README.md /tmp/out/README.md
run cp ./LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
