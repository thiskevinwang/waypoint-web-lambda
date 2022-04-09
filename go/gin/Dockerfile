FROM golang:1.18 as build-env

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

COPY --from=build-env /go/bin/app /
COPY swagger.yaml ./
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.3.2 /lambda-adapter /opt/extensions/lambda-adapter
EXPOSE 8080
CMD ["/app"]