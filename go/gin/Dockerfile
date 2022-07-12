FROM golang:1.18 as builder

WORKDIR /go/src/app
COPY *.go .

# Given imports like "main/db" and "main/db",
# these COPY commands help resolve the following issue:
# 
# > main/db: package main/db is not in GOROOT (/usr/local/go/src/main/db)
# > main/routes: package main/routes is not in GOROOT (/usr/local/go/src/main/routes)
COPY routes/*.go /usr/local/go/src/main/routes/
COPY db/*.go /usr/local/go/src/main/db/
COPY controllers/*.go /usr/local/go/src/main/controllers/
COPY middleware/*.go /usr/local/go/src/main/middleware/

RUN go mod init
RUN go get -d -v ./...
RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/app

# https://github.com/GoogleContainerTools/distroless/blob/main/examples/go/Dockerfile
FROM gcr.io/distroless/static
# FROM golang:1.18-alpine

COPY --from=builder /go/bin/app /
COPY swagger.yaml ./

# READINESS_CHECK_PORT and PORT are used by https://github.com/aws-samples/aws-lambda-adapter/blob/main/src/main.rs
ENV READINESS_CHECK_PORT=7531
ENV PORT=7531
COPY --from=ghcr.io/thiskevinwang/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter

CMD ["/app"]