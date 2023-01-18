FROM golang:1.18 as builder

WORKDIR /go/src/app
COPY *.go .

RUN go mod init
RUN go get -d -v ./...
RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

# https://github.com/GoogleContainerTools/distroless/blob/main/examples/go/Dockerfile
FROM gcr.io/distroless/static
# FROM golang:1.18-alpine

COPY --from=builder /go/bin/app /
COPY swagger.yaml ./

# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.6.0-x86_64 /lambda-adapter /opt/extensions/lambda-adapter

CMD ["/app"]