from debian:12-slim

run apt-get update && apt-get install -y \
        cmake clang bison flex xz-utils libfuse-dev libudev-dev pkg-config \
        libc6-dev-i386 libcap2-bin git git-lfs libglu1-mesa-dev libcairo2-dev \
        libgl1-mesa-dev libtiff5-dev libfreetype6-dev libxml2-dev libegl1-mesa-dev libfontconfig1-dev \
        libbsd-dev libxrandr-dev libxcursor-dev libgif-dev libpulse-dev libavformat-dev libavcodec-dev \
        libswresample-dev libdbus-1-dev libxkbfile-dev libssl-dev llvm-dev \
        git git-lfs
run git lfs install

run git clone --recursive https://github.com/darlinghq/darling.git /darling
workdir /darling

COPY ./build.sh ./build.sh

cmd bash ./build.sh
