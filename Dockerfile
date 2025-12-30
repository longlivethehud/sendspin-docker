FROM debian:bookworm

# ------------------------------------------------------------
# 1. System dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    git \
    yasm \
    nasm \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# 2. Build minimal FFmpeg with all APIs PyAV needs
# ------------------------------------------------------------
WORKDIR /opt

RUN git clone https://github.com/FFmpeg/FFmpeg.git && \
    cd FFmpeg && \
    git checkout n7.0 && \
    ./configure \
        --prefix=/usr/local \
        --enable-shared \
        --disable-static \
        --disable-programs \
        --disable-doc \
        --disable-debug \
        --disable-everything \
        --enable-avcodec \
        --enable-avformat \
        --enable-avutil \
        --enable-swresample \
        --enable-swscale \
        --enable-decoder=rawvideo \
        --enable-decoder=pcm_s16le \
        --enable-demuxer=rawvideo \
        --enable-demuxer=wav \
        && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# ------------------------------------------------------------
# 3. Install PyAV from source (links to our FFmpeg)
# ------------------------------------------------------------
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN pip install --no-binary av av

RUN pip install sendspin

# ------------------------------------------------------------
# 4. Optional: create a working directory
# ------------------------------------------------------------
WORKDIR /app

CMD ["sendspin --headless"]
