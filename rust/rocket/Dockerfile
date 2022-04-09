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
# lambda-adapter
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
EXPOSE 8080

# copy the binary into the final image
COPY --from=cargo-build /app/target/release/rust-rocket .

CMD ["/rust-rocket"]