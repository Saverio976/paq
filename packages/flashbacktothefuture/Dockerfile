from docker.io/epitechcontent/epitest-docker:latest

# use add to invalidate cache if sources has changed
run git clone --single-branch --branch main https://github.com/X-R-G-B/FlashBackToTheFuture.git /flashbacktothefuture
workdir /flashbacktothefuture

# build
run make -j4

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run mkdir -p /tmp/out/libs
run cp \
            /lib/x86_64-linux-gnu/libcsfml-graphics.so.2.5 \
            /lib/x86_64-linux-gnu/libcsfml-audio.so.2.5 \
            /lib/x86_64-linux-gnu/libcsfml-system.so.2.5 \
            /lib/x86_64-linux-gnu/libcsfml-window.so.2.5 \
            /lib/x86_64-linux-gnu/libsfml-graphics.so.2.5 \
            /lib/x86_64-linux-gnu/libsfml-audio.so.2.5 \
            /lib/x86_64-linux-gnu/libsfml-system.so.2.5 \
            /lib/x86_64-linux-gnu/libsfml-window.so.2.5 \
            /lib/x86_64-linux-gnu/libfreetype.so.6 \
            /lib/x86_64-linux-gnu/libstdc++.so.6 \
            /lib/x86_64-linux-gnu/libGL.so.1 \
            /lib/x86_64-linux-gnu/libX11.so.6 \
            /lib/x86_64-linux-gnu/libXrandr.so.2 \
            /lib/x86_64-linux-gnu/libudev.so.1 \
            /lib/x86_64-linux-gnu/libopenal.so.1 \
            /lib/x86_64-linux-gnu/libvorbisenc.so.2 \
            /lib/x86_64-linux-gnu/libvorbisfile.so.3 \
            /lib/x86_64-linux-gnu/libvorbis.so.0 \
            /lib/x86_64-linux-gnu/libogg.so.0 \
            /lib/x86_64-linux-gnu/libFLAC.so.12 \
            /lib/x86_64-linux-gnu/libGLX.so.0 \
            /lib/x86_64-linux-gnu/libXext.so.6 \
            /lib/x86_64-linux-gnu/libGLdispatch.so.0 \
            /lib/x86_64-linux-gnu/libbz2.so.1 \
            /lib/x86_64-linux-gnu/libpng16.so.16 \
            /lib/x86_64-linux-gnu/libz.so.1 \
            /lib/x86_64-linux-gnu/libharfbuzz.so.0 \
            /lib/x86_64-linux-gnu/libbrotlidec.so.1 \
            /lib/x86_64-linux-gnu/libxcb.so.1 \
            /lib/x86_64-linux-gnu/libXrender.so.1 \
            /lib/x86_64-linux-gnu/libcap.so.2 \
            /lib/x86_64-linux-gnu/libglib-2.0.so.0 \
            /lib/x86_64-linux-gnu/libgraphite2.so.3 \
            /lib/x86_64-linux-gnu/libbrotlicommon.so.1 \
            /lib/x86_64-linux-gnu/libXau.so.6 \
            /lib/x86_64-linux-gnu/libpcre2-8.so.0 \
            /tmp/out/libs
run cp ./my_rpg /tmp/out/my_rpg
run cp ./README.md /tmp/out/README.md
run cp ./LICENSE /tmp/out/LICENSE
run cp -r ./assets /tmp/out/assets
COPY ./flashbacktothefuture.sh /tmp/out/bin/flashbacktothefuture
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out
