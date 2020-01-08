FROM golang:1.13-alpine as BUILD

WORKDIR /go/src/github.com/grafana

RUN set -x \
  \
  && apk add --no-cache \
    git \
  \
  && git clone \
    https://github.com/grafana/loki.git \
  && cd loki \
  && GOOS=linux GO111MODULE=on CGO_ENABLED=0 \
    go build -v -a -ldflags '-w -s -extldflags "-static"' -o promtail ./cmd/promtail

FROM scratch

COPY --from=BUILD /go/src/github.com/grafana/loki/promtail /promtail
ENTRYPOINT ["/promtail"]