FROM docker.io/alpine:3.16.0

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	py3-dnspython
