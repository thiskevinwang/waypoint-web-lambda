# -----------------
# Cargo Build Stage
# -----------------


# Start with a rust alpine image
FROM rust:1.60.0-alpine AS cargo-build
RUN apk add --update cargo

# if needed, install dependencies here
#RUN apk add libseccomp-dev
# set the workdir and copy the source into it
WORKDIR /app
COPY Cargo.lock /app
COPY Cargo.toml /app
RUN mkdir .cargo
RUN cargo vendor > /app/.cargo/config

COPY ./src src
RUN cargo build --release
RUN cargo install --path . --verbose

# -----------------
# Final Stage
# -----------------

# FROM gcr.io/distroless/static
FROM alpine:latest
# Install bash to execute `wait-for-it.sh`
RUN apk add --no-cache bash 
WORKDIR /app

# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
# COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.6.0 /lambda-adapter /opt/extensions/lambda-adapter

# copy the binary into the final image
COPY --from=cargo-build /app/target/release/rust-rocket /app/rust-rocket

# copy wait-for-it.sh
COPY ./src/scripts/wait-for-it.sh /app/wait-for-it.sh

CMD ["/app/rust-rocket"]