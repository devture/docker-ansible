FROM docker.io/alpine:3.14.2

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	ansible \
	py3-dnspython
