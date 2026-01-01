FROM debian:bookworm

# ------------------------------------------------------------
# Install packaged dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    alsa-utils \
    bash \
    build-essential \
    checkinstall \
    curl \
    git \
    libasound2 \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libbz2-dev \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libjpeg-dev \
    liblzma-dev \
    libncursesw5-dev \
    libportaudio2 \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libswresample-dev \
    libswscale-dev \
    nasm \
    pkg-config \
    tk-dev \
    wget \
    yasm \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# Install Python 3.12.4 from source
# ------------------------------------------------------------

WORKDIR /opt

RUN wget https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz && \
    tar xvf Python-3.12.4.tgz && \
    cd Python-3.12.4 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall


# ------------------------------------------------------------
# Set up build environment
# Test for 64bit toolchain so that NEON and ASM can be disabled on 32bit
# ------------------------------------------------------------

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN set -eux; \
    if gcc -dumpmachine | grep -q aarch64; then \
        echo "ARCH_MODE=64bit" > /tmp/arch; \
    else \
        echo "ARCH_MODE=32bit" > /tmp/arch; \
    fi

# ------------------------------------------------------------
# Build x264 from source
# --disable-asm for 32bit builds to avoid build errors
# ------------------------------------------------------------

WORKDIR /opt

RUN git clone https://code.videolan.org/videolan/x264.git

WORKDIR /opt/x264

RUN . /tmp/arch && \
    if [ $ARCH_MODE = "32bit" ]; then \
        ./configure --enable-static --enable-pic \
        --disable-asm; \
    else \
        ./configure --enable-static --enable-pic; \
    fi

    RUN make -j$(nproc) && \
        make install && \
        ldconfig


# ------------------------------------------------------------
# Build FFmpeg from source
# --disable-asm and --disable-neon for 32bit builds to avoid build errors
# ------------------------------------------------------------
    
WORKDIR /opt

RUN git clone https://github.com/FFmpeg/FFmpeg.git

WORKDIR /opt/FFmpeg

RUN . /tmp/arch && \
    if [ $ARCH_MODE = "32bit" ]; then \
        ./configure \
        --disable-doc \
        --disable-static \
        --disable-stripping \
        --disable-libxml2 \
        --disable-asm \
        --disable-neon \
        --enable-debug=3 \
        --enable-gpl \
        --enable-version3 \
        --enable-libx264 \
        --enable-shared \
        --enable-sse \
        --enable-avx \
        --enable-avx2; \
    else \
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
        --enable-avx2; \
    fi

RUN make -j$(nproc) && \
    make install && \
    ldconfig

# ------------------------------------------------------------
# Install Sednspin and dependencies in a Python virtual environment)
# ------------------------------------------------------------

WORKDIR /app

RUN python3.12 -m venv pyav-build && \
    . pyav-build/bin/activate && \
    pip install --upgrade pip setuptools wheel && \
    pip install sendspin

# ------------------------------------------------------------
# Clean up our mess
# ------------------------------------------------------------

WORKDIR /opt

RUN rm -rf ./* && rm -rf ./.??*

# ------------------------------------------------------------
# Set up sendspin-cli to run on container start
# ------------------------------------------------------------

WORKDIR /app

ENV PATH="/app/pyav-build/bin:${PATH}"

ENTRYPOINT ["/bin/sh", "-c", "$0 \"$@\"", "sendspin"]