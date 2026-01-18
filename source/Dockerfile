# ------------------------------------------------------------
# Build file for 32 bit ARM architectures
# ------------------------------------------------------------
FROM debian:stable AS pre-build

ARG TARGETPLATFORM

# ------------------------------------------------------------
# Install dev packaged dependencies
# ------------------------------------------------------------
RUN case "$TARGETPLATFORM" in \
    "linux/arm/v7"|"linux/arm/v8") \
        echo "Installing 32bit ARM dependencies" ; \
        apt-get update && apt-get install -y \
            build-essential \
            libavcodec-dev \
            libavdevice-dev \
            libavfilter-dev \
            libavformat-dev \
            libavutil-dev \
            libportaudio2 \
            libswresample-dev \
            libswscale-dev \
            pkg-config \
            python3-dev \
            libffi-dev \
            libjpeg-dev ; \
            ;; \
    *) \
        echo "Skipping 32bit ARM dependencies" ; \
        mkdir -p /usr/lib/arm-linux-gnueabihf ; \
        ;; \
    esac

# ------------------------------------------------------------
# Pull a separate base image for a clean final build
# ------------------------------------------------------------
FROM debian:stable AS final-build

ARG TARGETPLATFORM

# ------------------------------------------------------------
# Copy necessary libraries from the build image to the final image
# ------------------------------------------------------------
COPY --from=pre-build /usr/lib/arm-linux-gnueabihf /usr/lib/arm-linux-gnueabihf

COPY --from=pre-build /usr/include /usr/include

COPY --from=pre-build /usr/lib /usr/lib

# ------------------------------------------------------------
# Install runtime dependencies
# ------------------------------------------------------------
RUN case "$TARGETPLATFORM" in \
    "linux/arm/v7"|"linux/arm/v8") \
        echo "Installing 32bit ARM runtime dependencies" ; \
        apt-get update && apt-get install -y \
        alsa-utils \
        bash \
        libportaudio2 \
        pkg-config \
        python3 \
        python3-pip \
        pipx ; \
        ;; \
    *) \
        echo "Installing 64bit runtime dependencies" ; \
        apt-get update && apt-get install -y \
        libportaudio2 \
        python3 \
        python3-pip \
        pipx ; \
        ;; \
    esac

WORKDIR /app

# ------------------------------------------------------------
# Clean up apt cache to reduce image size   
# ------------------------------------------------------------
RUN rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------------
# Install sendspin
# ------------------------------------------------------------
RUN pipx install sendspin

RUN --mount=type=cache,id=upgrade-sendpsin pipx upgrade sendspin

ENV PATH="/root/.local/bin:${PATH}"

# ------------------------------------------------------------
# Setup entrypoint to call entrypoint.sh and run sendspin with passed arguments
# ------------------------------------------------------------
ENTRYPOINT ["/bin/sh", "-c", "$0 \"$@\"", "sendspin"]