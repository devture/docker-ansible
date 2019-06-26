FROM alpine:3.10

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	ansible \
	py3-dnspython
