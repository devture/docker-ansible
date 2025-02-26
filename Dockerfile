FROM docker.io/golang:1.24.0-alpine3.21 AS builder

ARG AGRU_VERSION=v0.1.15

RUN apk add --no-cache git just

RUN git clone https://github.com/etkecc/agru.git && \
				cd agru && \
				git checkout ${AGRU_VERSION} && \
				just build


FROM docker.io/alpine:3.21.3

COPY --from=builder /go/agru/agru /usr/local/bin/

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	make \
	just \
	py3-dnspython \
	py3-passlib
