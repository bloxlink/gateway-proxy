# FROM gelbpunkt/gateway-proxy:x86-64

# COPY ./config.json /config.json

# EXPOSE 7878

# CMD ["/gateway-proxy"]

# I will only support x86_64 hosts because this allows for best hardware optimizations.
# # Compiling a Dockerfile for aarch64 should work but I won't support it myself.
# FROM rust:latest as builder

# ARG TARGET_CPU="aarch64-unknown-linux-gnu"

# WORKDIR /app

# # Install necessary dependencies for QEMU and the project
# RUN dpkg --add-architecture arm64 \
#     && apt-get update && apt-get install -y --no-install-recommends \
#     qemu-user-static \
#     binutils \
#     cmake \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# COPY . .

# RUN rustup toolchain install nightly-${TARGET_CPU}
# RUN rustup default stable
# # Build the project using QEMU
# # RUN cargo build --release --target=$TARGET_CPU-unknown-linux-gnu
# RUN rustup component add rust-src --toolchain nightly-${TARGET_CPU}
# RUN cargo build --release --target=$TARGET_CPU

# RUN cp /app/target/$TARGET_CPU/release/gateway-proxy /gateway-proxy && \
#     strip /gateway-proxy
# # RUN cp /app/target/${TARGET_CPU}/release/gateway-proxy /gateway-proxy
# COPY ./config.json ./config.json

# # FROM alpine:3.18

# # ARG TARGET_CPU="aarch64-unknown-linux-gnu"

# # COPY --from=builder /app/target/${TARGET_CPU}/release/gateway-proxy /gateway-proxy
# # # RUN cp /app/target/${TARGET_CPU}/release/gateway-proxy /gateway-proxy
# # COPY ./config.json ./config.json
# # CMD [ "/gateway-proxy" ]

# FROM scratch

# COPY --from=builder /gateway-proxy /gateway-proxy

# CMD ["./gateway-proxy"]

# ARG TARGET_CPU="aarch64-unknown-linux-gnu"

# COPY --from=builder /app/target/${TARGET_CPU}/release/gateway-proxy /gateway-proxy
# RUN --from=builder cp /app/target/$TARGET_CPU/release/gateway-proxy /gateway-proxy && \
#     strip /gateway-proxy
# # RUN cp /app/target/${TARGET_CPU}/release/gateway-proxy /gateway-proxy
# COPY ./config.json ./config.json

# FROM scratch

# COPY --from=builder /gateway-proxy .

# CMD ["/gateway-proxy"]

# CMD [ "./gateway-proxy" ]

# FROM debian:stable-slim
# WORKDIR /gateway-proxy
# RUN cp /app/target/$TARGET_CPU/release/gateway-proxy /gateway-proxy && \
#     strip /gateway-proxy
# COPY --from=builder /app/target/$TARGET_CPU/release/gateway-proxy /gateway-proxy
# COPY --from=builder ./config.json /config.json
# COPY ./config.json ./config.json

# FROM scratch

# COPY --from=builder /gateway-proxy /gateway-proxy

# CMD ["/gateway-proxy"]

# EXPOSE 7878
# # COPY --from=builder /build/gateway-proxy .

# CMD ["./gateway-proxy"]



# FROM rust:latest

# ENV CROSS_CONTAINER_IN_CONTAINER=true

# WORKDIR /src
# COPY . .

# RUN cargo install cross
# # RUN cargo install -f cross
# # RUN cross build --target aarch64-unknown-linux-gnu
# # RUN cargo install cross --git https://github.com/cross-rs/cross
# RUN cross build --release --target aarch64-unknown-linux-gnu

# # RUN rustup toolchain install nightly-aarch64-unknown-linux-gnu
# # RUN rustup default stable
# # RUN rustup component add rust-src --toolchain nightly-aarch64-unknown-linux-gnu
# # RUN cargo build --release --target=aarch64-unknown-linux-gnu

# FROM alpine:3.18
# COPY --from=builder /src/target/release/gateway-proxy /gateway-proxy
# CMD [ "/gateway-proxy" ]


# FROM rust:1

# ENV CROSS_CONTAINER_IN_CONTAINER=true

# RUN apt update && apt install -y docker.io
# Update default packages
# RUN apt-get -qq update

# # Get Ubuntu packages
# RUN apt-get install -y -q \
#     build-essential \
#     openssl \
#     make \
#     cmake \
#     pkg-config \
#     libssl-dev \
#     libpq-dev \
#     curl

# RUN cargo install cross --git https://github.com/cross-rs/cross

# # COPY . .

# WORKDIR /build
# COPY . .

# RUN rustup target add aarch64-unknown-linux-gnu

# ENV CARGO_TARGET_DIR=/build
# RUN cross build --target aarch64-unknown-linux-gnu --release

# FROM debian:stable-slim
# WORKDIR /app
# COPY --from=base /build/my-app .

# CMD ["./my-app"]

# ENV CARGO_TARGET_DIR=/build
# RUN cross build --target aarch64-unknown-linux-gnu --release

# FROM debian:stable-slim
# WORKDIR /app
# COPY --from=base /build/my-app .

# CMD ["./my-app"]


# RUN cross build --target aarch64-unknown-linux-gnu

# WORKDIR /build
# COPY . .
# RUN rustup target add aarch64-apple-darwin

# ENV CARGO_TARGET_DIR=/build
# RUN cross build --target aarch64-apple-darwin --release

# FROM debian:stable-slim
# WORKDIR /app
# COPY --from=base /build/my-app .

# CMD ["./my-app"]

# FROM messense/rust-musl-cross:aarch64-musl
# RUN rustup update beta && \
#     rustup target add --toolchain beta aarch64-unknown-linux-musl

# WORKDIR /usr/src/gateway-proxy
# COPY . .
# RUN cargo build --release --target aarch64-unknown-linux-musl

# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
# COPY --from=0 /usr/src/gateway-proxy/target/aarch64-unknown-linux-musl/release/gateway-proxy /usr/local/bin/gateway-proxy
# CMD ["/usr/local/bin/gateway-proxy"]


# I will only support x86_64 hosts because this allows for best hardware optimizations.
# Compiling a Dockerfile for aarch64 should work but I won't support it myself.
# ARG TARGET_CPU="x86_64-apple-darwin"

# FROM docker.io/library/alpine:edge AS builder
# ARG TARGET_CPU
# ENV RUST_TARGET "aarch64-apple-darwin"
# ENV RUSTFLAGS "-Lnative=/usr/lib -C target-cpu=${TARGET_CPU}"

# RUN apk upgrade && \
#     apk add curl gcc g++ musl-dev cmake make && \
#     curl -sSf https://sh.rustup.rs | sh -s -- --profile minimal --component rust-src --default-toolchain nightly -y

# WORKDIR /build

# COPY Cargo.toml Cargo.lock ./
# COPY .cargo ./.cargo/

# RUN mkdir src/
# RUN echo 'fn main() {}' > ./src/main.rs
# RUN source $HOME/.cargo/env && \
#     if [ "$TARGET_CPU" == 'x86-64' ]; then \
#         cargo build --release --target="$RUST_TARGET" --no-default-features --features no-simd; \
#     else \
#         cargo build --release --target="$RUST_TARGET"; \
#     fi

# RUN rm -f target/$RUST_TARGET/release/deps/gateway_proxy*
# COPY ./src ./src

# RUN source $HOME/.cargo/env && \
#     if [ "$TARGET_CPU" == 'x86-64' ]; then \
#         cargo build --release --target="$RUST_TARGET" --no-default-features --features no-simd; \
#     else \
#         cargo build --release --target="$RUST_TARGET"; \
#     fi && \
#     cp target/$RUST_TARGET/release/gateway-proxy /gateway-proxy && \
#     strip /gateway-proxy

# FROM scratch

# COPY --from=builder /gateway-proxy /gateway-proxy

# CMD ["./gateway-proxy"]

# I will only support x86_64 hosts because this allows for best hardware optimizations.
# Compiling a Dockerfile for aarch64 should work but I won't support it myself.
ARG TARGET_CPU="haswell"

FROM docker.io/library/alpine:edge AS builder
ARG TARGET_CPU
ARG RUST_TARGET "x86_64-unknown-linux-musl"
ENV RUSTFLAGS "-Lnative=/usr/lib -C target-cpu=${TARGET_CPU}"

RUN apk upgrade && \
    apk add curl gcc g++ musl-dev cmake make && \
    curl -sSf https://sh.rustup.rs | sh -s -- --profile minimal --component rust-src --default-toolchain nightly -y

WORKDIR /build

COPY Cargo.toml Cargo.lock ./
COPY .cargo ./.cargo/

RUN mkdir src/
RUN echo 'fn main() {}' > ./src/main.rs
RUN source $HOME/.cargo/env && \
    if [ "$TARGET_CPU" == 'x86-64' ]; then \
        cargo build --release --target="$RUST_TARGET" --no-default-features --features no-simd; \
    else \
        cargo build --release --target="$RUST_TARGET"; \
    fi

RUN rm -f target/$RUST_TARGET/release/deps/gateway_proxy*
COPY ./src ./src

RUN source $HOME/.cargo/env && \
    if [ "$TARGET_CPU" == 'x86-64' ]; then \
        cargo build --release --target="$RUST_TARGET" --no-default-features --features no-simd; \
    else \
        cargo build --release --target="$RUST_TARGET"; \
    fi && \
    cp target/$RUST_TARGET/release/gateway-proxy /gateway-proxy && \
    strip /gateway-proxy

FROM scratch

COPY --from=builder /gateway-proxy /gateway-proxy
COPY ./config.json ./config.json

CMD ["./gateway-proxy"]