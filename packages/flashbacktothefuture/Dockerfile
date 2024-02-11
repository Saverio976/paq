from epitechcontent/epitest-docker:latest

run dnf update -y
run dnf install -y git

# use add to invalidate cache if sources has changed
ADD https://github.com/X-R-G-B/FlashBackToTheFuture/archive/refs/heads/main.zip /tmp/sum
run git clone https://github.com/X-R-G-B/FlashBackToTheFuture.git /flashbacktothefuture
workdir /flashbacktothefuture
run git checkout main

# build
run make

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp ./my_rpg /tmp/out/bin/my_rpg
COPY ./flashbacktothefuture.sh /tmp/out/bin/flashbacktothefuture
run cp ./README.md /tmp/out/README.md
run cp ./LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
