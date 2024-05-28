FROM alpine:3.20
WORKDIR /opt/vlang
ENV PATH /opt/vlang:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
## install development packages
RUN apk --no-cache add \
  musl-dev libc-dev libc6-compat gcompat
RUN apk --no-cache add \
  openssl-dev sqlite-dev mbedtls \
  libuv-dev libev-dev libevent-dev libmemcached-dev
RUN apk --no-cache add \
  binutils diffutils elfutils pcre strace \
  libunwind-dev libunwind-static gc
RUN apk --no-cache add \
  make bash file git upx
RUN apk --no-cache add gcc gdb wasi-sdk
RUN apk --no-cache add \
  mesa-dev mesa-gl mesa-gles mesa-glapi \
  glfw-dev \
  glu-dev \
  glew-dev \
  freetype-dev \
  freeglut-dev \
  libxi-dev libxi-static \
  libxcursor-dev \
  libx11-dev
RUN apk --no-cache add \
  icu-data-full \
  sdl2_net-dev \
  sdl2_gfx-dev \
  sdl2_ttf-dev \
  sdl2_image-dev \
  sdl2_mixer-dev \
  sdl2_pango-dev \
  sdl2-dev
RUN ln -s /opt/vlang/v /usr/local/bin/v
RUN git clone --depth=1 --quiet https://github.com/vlang/v/ /opt/vlang
RUN mkdir -p /tmp/v /tmp/v /home/
## setup runtime environment for v and bash:
ENV HOME     /home
ENV VTMP     /tmp/v
ENV VMODULES /tmp/vmodules
RUN make && v -version && ls -la v
RUN du -b -s .
RUN time v -prod -skip-unused doctor
RUN time v -prod -skip-unused self
RUN time v -prod -skip-unused cmd/tools/vfmt.v
RUN find . -type f -name *_test.v -or -name *.vv -or -name *.out | xargs rm
RUN rm -rf v_old vc/ .git/
RUN du -b -s .

RUN git clone --single-branch --branch main https://github.com/Saverio976/paq.git /paq
WORKDIR /paq
RUN make paq-release

RUN mkdir -p /tmp/out/bin
RUN cp /paq/paq /tmp/out/bin/paq
RUN cp /paq/README.md /tmp/out/README.md
RUN cp /paq/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
RUN echo "version = \"$(git describe main --tags --abbrev=0)\"" >> /tmp/out/metadata.toml

# cmd
CMD cp -r /tmp/out/* /out
