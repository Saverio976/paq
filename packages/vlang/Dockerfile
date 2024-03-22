from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl git make gcc

run git clone --single-branch --branch master https://github.com/vlang/v /vlang
workdir /vlang
run make

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/
run cp -r /vlang /tmp/out/
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(sh -c '/tmp/out/vlang/v --version' | awk '{print $2 " " $3}')\"" >> /tmp/out/metadata.toml
run cd /tmp/out \
    && echo "chmod = [" >> /tmp/out/metadata.toml \
    && find -type f -executable -print | awk '{print "    {path = \"" $1 "\", mode = \"binary\"},"}' >> /tmp/out/metadata.toml \
    && echo "]" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
