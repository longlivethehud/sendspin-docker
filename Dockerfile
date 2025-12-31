FROM debian:bookworm

# ------------------------------------------------------------
# 1. System dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    pkg-config \
    git \
    yasm \
    nasm \
    wget \
    curl \
    alsa-utils \
    libasound2 \
    libportaudio2 \
    checkinstall \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    libffi-dev \
    liblzma-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libavfilter-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz && \
    tar xvf Python-3.12.4.tgz && \
    cd Python-3.12.4 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall

# ------------------------------------------------------------
# 2. Build minimal FFmpeg with all APIs PyAV needs
# ------------------------------------------------------------


# ------------------------------------------------------------
# 3. Install PyAV from source (links to our FFmpeg)
# ------------------------------------------------------------

WORKDIR /opt

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN git clone https://code.videolan.org/videolan/x264.git && \
    cd x264 && \
    ./configure --enable-static --enable-pic && \
    make -j$(nproc) && \
    make install && \
    ldconfig

WORKDIR /opt

RUN git clone https://github.com/FFmpeg/FFmpeg.git && \
    cd FFmpeg && \
    ./configure \
    --disable-doc \
    --disable-static \
    --disable-stripping \
    --disable-libxml2 \
    --enable-debug=3 \
    --enable-gpl \
    --enable-version3 \
    --enable-libx264 \
    --enable-shared \
    --enable-sse \
    --enable-avx \
    --enable-avx2 \
        && \
    make -j$(nproc) && \
    make install && \
    ldconfig

WORKDIR /app

RUN python3.12 -m venv pyav-build && \
    . pyav-build/bin/activate && \    
    pip install --upgrade pip setuptools wheel && \
    pip install sendspin


WORKDIR /app

ENV PATH="/app/pyav-build/bin:${PATH}"

CMD ["sendspin --headless"]
