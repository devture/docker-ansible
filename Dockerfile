FROM docker.io/golang:1.26.5-alpine3.24 AS builder

ARG AGRU_VERSION=v0.2.1

RUN apk add --no-cache git just

RUN git clone https://github.com/etkecc/agru.git && \
	cd agru && \
	git checkout ${AGRU_VERSION} && \
	just build


FROM docker.io/alpine:3.24.1

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
