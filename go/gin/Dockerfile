FROM golang:1.18 as build-env

WORKDIR /go/src/app
COPY *.go .

RUN go mod init
RUN go get -d -v ./...
RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

# https://github.com/GoogleContainerTools/distroless/blob/main/examples/go/Dockerfile
FROM gcr.io/distroless/static

COPY --from=build-env /go/bin/app /
CMD ["/app"]