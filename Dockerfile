# FROM gelbpunkt/gateway-proxy:x86-64

# COPY ./config.json /config.json

# EXPOSE 7878

# CMD ["/gateway-proxy"]

# I will only support x86_64 hosts because this allows for best hardware optimizations.
# Compiling a Dockerfile for aarch64 should work but I won't support it myself.
FROM rust:latest

ARG TARGET_CPU="aarch64"
WORKDIR /app

# Install necessary dependencies for QEMU and the project
RUN dpkg --add-architecture arm64 \
    && apt-get update && apt-get install -y --no-install-recommends \
    qemu-user-static \
    binutils \
    cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN rustup toolchain install nightly-aarch64-unknown-linux-gnu
RUN rustup default stable
# Build the project using QEMU
# RUN cargo build --release --target=$TARGET_CPU-unknown-linux-gnu
RUN rustup component add rust-src --toolchain nightly-aarch64-unknown-linux-gnu
RUN cargo build --release --target=aarch64-unknown-linux-gnu


# # CMD instruction
CMD ["target", "/app/target/$TARGET_CPU-unknown-linux-gnu/release/gateway-proxy"]
