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

# Since Ansible 2.21, forked workers lose the controlling terminal, so SSH cannot
# prompt for confirming an unknown host key — it fails or hangs instead
# (https://github.com/devture/docker-ansible/issues/6). This container is also thrown
# away after each use, so a key confirmed via a prompt would not be remembered anyway.
# We therefore auto-accept the keys of previously unknown hosts.
# A host whose key has *changed* still fails loudly.
RUN printf '\nHost *\n\tStrictHostKeyChecking accept-new\n' >> /etc/ssh/ssh_config
