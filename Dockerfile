FROM docker.io/alpine:3.16.2

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	make \
	py3-dnspython
