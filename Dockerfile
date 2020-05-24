FROM alpine:3.11

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	ansible \
	py3-dnspython
