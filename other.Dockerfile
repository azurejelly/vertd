FROM rust:1.86 AS builder

WORKDIR /build

COPY . .

RUN cargo build --release

FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y ffmpeg

WORKDIR /app

COPY --from=builder /build/target/release/vertd ./vertd

ENTRYPOINT ["./vertd"]