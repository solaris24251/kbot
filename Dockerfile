FROM golang:1.19 as builder

ARG APP_VERSION v.1.0.0

WORKDIR /go/src/app
COPY . .
RUN apk update \
        && apk upgrade \
        && apk add --no-cache \
        ca-certificates \
        && update-ca-certificates 2>/dev/null || true
RUN go get -d -v .
RUN export GOPATH=/go
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=$APP_VERSION

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
WORKDIR /
COPY --from=builder /go/src/app/kbot .
ENTRYPOINT ["./kbot", "start"]