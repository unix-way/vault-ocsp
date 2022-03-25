FROM golang as builder
WORKDIR /go/src/vault-ocsp
COPY . .
RUN go get -v && \
    CGO_ENABLED="0" go build -o vault-ocsp

FROM alpine:3.10
RUN addgroup vault && \
    adduser -S -G vault vault
RUN mkdir -p /ocsp/ssl && \
    chown -R vault:vault /ocsp
RUN apk add dumb-init su-exec
COPY --from=builder /go/src/vault-ocsp/vault-ocsp /usr/local/bin/vault-ocsp
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["vault-ocsp"]
