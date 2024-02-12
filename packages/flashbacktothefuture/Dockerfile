from docker.io/epitechcontent/epitest-docker:latest

# use add to invalidate cache if sources has changed
ADD https://github.com/X-R-G-B/FlashBackToTheFuture/archive/refs/heads/main.zip /tmp/sum
run git clone https://github.com/X-R-G-B/FlashBackToTheFuture.git /flashbacktothefuture
workdir /flashbacktothefuture
run git checkout main

# build
run make

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run mkdir -p /tmp/out/libs
run cp /lib64/libcsfml-graphics.so.2.5 /tmp/out/libs/
run cp /lib64/libcsfml-audio.so.2.5 /tmp/out/libs/
run cp /lib64/libcsfml-system.so.2.5 /tmp/out/libs/
run cp /lib64/libcsfml-window.so.2.5 /tmp/out/libs/
run cp /lib64/libsfml-graphics.so.2.5 /tmp/out/libs/
run cp /lib64/libsfml-audio.so.2.5 /tmp/out/libs/
run cp /lib64/libsfml-system.so.2.5 /tmp/out/libs/
run cp /lib64/libsfml-window.so.2.5 /tmp/out/libs/
run cp /lib64/libfreetype.so.6 /tmp/out/libs/
run cp /lib64/libstdc++.so.6 /tmp/out/libs/
run cp /lib64/libGL.so.1 /tmp/out/libs/
run cp /lib64/libX11.so.6 /tmp/out/libs/
run cp /lib64/libXrandr.so.2 /tmp/out/libs/
run cp /lib64/libudev.so.1 /tmp/out/libs/
run cp /lib64/libopenal.so.1 /tmp/out/libs/
run cp /lib64/libvorbisenc.so.2 /tmp/out/libs/
run cp /lib64/libvorbisfile.so.3 /tmp/out/libs/
run cp /lib64/libvorbis.so.0 /tmp/out/libs/
run cp /lib64/libogg.so.0 /tmp/out/libs/
run cp /lib64/libFLAC.so.12 /tmp/out/libs/
run cp /lib64/libGLX.so.0 /tmp/out/libs/
run cp /lib64/libXext.so.6 /tmp/out/libs/
run cp /lib64/libGLdispatch.so.0 /tmp/out/libs/
run cp /lib64/libbz2.so.1 /tmp/out/libs/
run cp /lib64/libpng16.so.16 /tmp/out/libs/
run cp /lib64/libz.so.1 /tmp/out/libs/
run cp /lib64/libharfbuzz.so.0 /tmp/out/libs/
run cp /lib64/libbrotlidec.so.1 /tmp/out/libs/
run cp /lib64/libxcb.so.1 /tmp/out/libs/
run cp /lib64/libXrender.so.1 /tmp/out/libs/
run cp /lib64/libcap.so.2 /tmp/out/libs/
run cp /lib64/libglib-2.0.so.0 /tmp/out/libs/
run cp /lib64/libgraphite2.so.3 /tmp/out/libs/
run cp /lib64/libbrotlicommon.so.1 /tmp/out/libs/
run cp /lib64/libXau.so.6 /tmp/out/libs/
run cp /lib64/libpcre2-8.so.0 /tmp/out/libs/
run cp ./my_rpg /tmp/out/my_rpg
run cp ./README.md /tmp/out/README.md
run cp ./LICENSE /tmp/out/LICENSE
run cp -r ./assets /tmp/out/assets
COPY ./flashbacktothefuture.sh /tmp/out/bin/flashbacktothefuture
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
