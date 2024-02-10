from haskell:latest

# install deps
run apt-get update -y
run apt-get install -y git

# build
run git clone https://github.com/X-R-G-B/Leviator.git /leviator
workdir /leviator
run ./scripts/InstallDepsLinux.sh
run make

# generate files packaged
run cp ./lvtc/lvtc /tmp/out/bin/lvtc
run cp ./lvtrun/lvtrun /tmp/out/bin/lvtrun
run cp ./README.md /tmp/out/README.md
run cp ./LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd ["cp", "-r", "/tmp/out", "/out"]
