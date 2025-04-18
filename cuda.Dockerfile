FROM rust:1.86 AS builder

WORKDIR /build

COPY . .

RUN cargo build --release

FROM nvidia/cuda:12.8.0-base-ubuntu24.04

RUN apt-get update && apt-get install -y \
    ffmpeg \
    pciutils \
    vulkan-tools \
    mesa-utils

WORKDIR /app

COPY --from=builder /build/target/release/vertd ./vertd

# Use CMD to display CUDA terms thing on container startup
CMD ["./vertd"]