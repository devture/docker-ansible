FROM docker.io/alpine:3.17.2

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	make \
	py3-dnspython
