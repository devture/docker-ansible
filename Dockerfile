FROM docker.io/alpine:edge

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	py3-dnspython
