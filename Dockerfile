ARG ARCH=
FROM ${ARCH}golang:1.21-alpine3.18 as builder

WORKDIR /app/src
RUN apk add -U make git grep
COPY . .
RUN make build

FROM ${ARCH}alpine:3.18 as container

WORKDIR /app
COPY --from=builder /app/src/idrac_exporter /app/bin/
RUN apk add -U bash
COPY default-config.yml /etc/prometheus/idrac.yml
COPY entrypoint.sh /app
ENTRYPOINT ["/app/entrypoint.sh"]
