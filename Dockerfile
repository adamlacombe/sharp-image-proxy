FROM node:10

RUN apt-get update \
    && apt-get -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git \
    libass-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtheora-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    mercurial \
    pkg-config \
    texinfo \
    wget \
    zlib1g-dev \
    nasm \
    yasm \
    libvpx-dev \
    libopus-dev \
    libx264-dev \
    libmp3lame-dev


# Install libaom from source.
RUN mkdir -p ~/ffmpeg_sources/libaom && \
  cd ~/ffmpeg_sources/libaom && \
  git clone https://aomedia.googlesource.com/aom && \
  cmake ./aom -DBUILD_SHARED_LIBS=1 && \
  make && \
  make install

# Install libx265 from source.
RUN cd ~/ffmpeg_sources && \
  git clone https://bitbucket.org/multicoreware/x265_git.git && \
  cd x265_git/build/linux && \
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
  make && \
  make install

ARG LIBDE265_VERSION=1.0.5
ARG LIBHEIF_VERSION=1.7.0

ARG LIBDE265_URL=https://github.com/strukturag/libde265/releases/download/v${LIBDE265_VERSION}
RUN cd /usr/local/src \
    && curl -L -O ${LIBDE265_URL}/libde265-${LIBDE265_VERSION}.tar.gz \
    && tar xzf libde265-${LIBDE265_VERSION}.tar.gz \
    && cd libde265-${LIBDE265_VERSION} \
    && ./configure --disable-dec265 --disable-sherlock265 \
    && make V=0 \
    && make install

# ARG LIBHEIF_URL=https://github.com/strukturag/libheif/releases/download/v${LIBHEIF_VERSION}
# RUN cd /usr/local/src \
#     && curl -L -O ${LIBHEIF_URL}/libheif-${LIBHEIF_VERSION}.tar.gz \
#     && tar xzf libheif-${LIBHEIF_VERSION}.tar.gz \
#     && cd libheif-${LIBHEIF_VERSION} \
#     && ./configure \
#     && make \
#     && make install

RUN cd /usr/local/src \
    && git clone https://github.com/strukturag/libheif.git \
    && cd libheif \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install

# ldd node_modules/sharp/build/Release/sharp.node
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download
RUN apt-get install -y gtk-doc-tools gobject-introspection \
    gtk-doc-tools \
    gobject-introspection \
    python3-pip \
    python3-setuptools \
    python3-wheel \ 
    libfftw3-dev \
    libexif-dev \
    libpng-dev \ 
    libtiff5-dev \ 
    libexpat1-dev \ 
    libcfitsio-dev \ 
    libgsl-dev \ 
    libmatio-dev \ 
    libnifti-dev \
    liborc-0.4-dev \ 
    liblcms2-dev \ 
    libpoppler-glib-dev \ 
    librsvg2-dev \ 
    libgif-dev \
    libopenexr-dev \
    libpango1.0-dev \ 
    libgsf-1-dev \
    libopenslide-dev \ 
    libffi-dev

ARG WEBP_VERSION=1.1.0
ARG WEBP_URL=https://storage.googleapis.com/downloads.webmproject.org/releases/webp

RUN cd /usr/local/src \
    && wget ${WEBP_URL}/libwebp-${WEBP_VERSION}.tar.gz \
    && tar xzf libwebp-${WEBP_VERSION}.tar.gz \
    && cd libwebp-${WEBP_VERSION} \
    && ./configure --enable-libwebpmux --enable-libwebpdemux \
    && make V=0 \
    && make install

RUN cd /usr/local/src \
    && git clone https://github.com/libvips/libvips.git \
    && cd libvips \
    && ./autogen.sh \
    && CFLAGS=-O3 CXXFLAGS=-O3 ./configure \
    && make V=0 \
    && make install

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/usrlocal.conf && ldconfig -v

RUN npm run build

EXPOSE 8080

CMD [ "npm", "run", "start" ]
