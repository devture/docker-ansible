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
	py3-passlib \
	py3-regex

# Since Ansible 2.21, forked workers call `setsid()` and thus lose the controlling terminal.
# SSH cannot open `/dev/tty` anymore, so it can no longer ask about unknown host keys
# or prompt for the passphrase of an SSH key, failing with `Host key verification failed` instead.
#
# This image is meant to be used interactively (see the `docker run -it` invocations in the README),
# where these prompts are expected to work, so we restore the previous behavior.
#
# Pass `-e ANSIBLE_WORKER_SESSION_ISOLATION=True` to `docker run` to get the Ansible default back.
ENV ANSIBLE_WORKER_SESSION_ISOLATION=False
