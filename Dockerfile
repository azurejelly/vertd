FROM rust:1.86 AS builder

WORKDIR /build

COPY . .

RUN cargo build --release

FROM nvidia/cuda:12.8.0-base-ubuntu24.04

WORKDIR /app

ARG DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

COPY --from=builder /build/target/release/vertd ./vertd

RUN apt-get update && apt-get install -y \
    ffmpeg \
    mesa-va-drivers \
    vulkan-tools

RUN rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENTRYPOINT ["./vertd"]