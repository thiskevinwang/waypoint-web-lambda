FROM golang:1.18 as builder

WORKDIR /go/src/app
COPY *.go .

RUN go mod init
RUN go get -d -v ./...
RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

# https://github.com/GoogleContainerTools/distroless/blob/main/examples/go/Dockerfile
# FROM gcr.io/distroless/static
FROM golang:1.18-alpine

COPY --from=builder /go/bin/app /
COPY swagger.yaml ./

# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
# COPY ./aws-lambda-extensions/cache-extension-demo/bin/extensions/cache-extension-demo /opt/extensions/cache-extension-demo


# ENV VAULT_AUTH_PROVIDER=aws
# ENV VAULT_ADDR=https://vault-cluster.vault.8d665260-7876-46c5-acf2-f0b549312fe4.aws.hashicorp.cloud:8200

# This is used by cache-extension-demo
# ENV CACHE_EXTENSION_INIT_STARTUP=true
# The aws-lambda-extensions dir is .dockerignore'd
COPY \
    cache-extension-demo \
    /opt/extensions/cache-extension-demo
# panic: open /var/task/config.yaml: no such file or directory
COPY \
    config.yaml \
    /var/task/config.yaml



CMD ["/app"]

# Failed run:
# - this run i used ARM GOARCH
# - GOOS=linux GOARCH=arm64 go build -o bin/extensions/cache-extension-demo main.go
# https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/$252Faws$252Flambda$252Fgin/log-events/2022$252F05$252F07$252F$255B$2524LATEST$255Db865afe570114cc1837ebdbf1d389eac

# Success ?
# - this run I copied over config.yaml
# https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/$252Faws$252Flambda$252Fgin/log-events/2022$252F05$252F07$252F$255B$2524LATEST$255Db2aed7b3f0fe4ef0bcc136cb9a735e89