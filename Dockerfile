FROM golang:1.13-alpine as BUILD
ARG VERSION=v1.5.0

WORKDIR /go/src/github.com/grafana

RUN set -x \
  \
  && apk add --no-cache \
    git \
  \
  && git clone -b $VERSION \
    https://github.com/grafana/loki.git \
  && cd loki \
  && CGO_ENABLED=0 GOOS=linux GO111MODULE=on \
    go build -v -ldflags '-s -w' -o promtail ./cmd/promtail

FROM scratch

COPY --from=BUILD /go/src/github.com/grafana/loki/promtail /promtail
ENTRYPOINT ["/promtail"]
