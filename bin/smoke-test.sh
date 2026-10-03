#!/usr/bin/env bash

# Checks that the given image contains working versions of the tools it
# promises: Ansible (with the collections and Python libraries playbooks rely
# on), agru, just, make, git and an SSH client configured to accept unknown
# host keys.
#
# Usage: bin/smoke-test.sh <image>

set -euo pipefail

image="${1:?Usage: $0 <image>}"

docker run --rm -i --entrypoint /bin/sh "$image" -eu <<'SCRIPT'
ansible --version
ansible-playbook --version > /dev/null
agru -version
just --version
make --version | head -n1
git --version
ssh -V

echo 'Python libraries:'
python3 -c 'import dns.resolver, passlib.hash, regex; print("ok")'

# Used for running Ansible against the host the container runs on.
echo 'community.docker.nsenter connection plugin:'
ansible-doc -t connection community.docker.nsenter > /dev/null
echo 'ok'

echo 'Running a task:'
ANSIBLE_LOCALHOST_WARNING=False ansible localhost -m ansible.builtin.debug -a "msg={{ 'password' | password_hash('sha512', 'smoketestsalt') }}"

echo 'SSH host key checking:'
ssh -G example.com 2> /dev/null | grep -qx 'stricthostkeychecking accept-new'
echo 'ok'
SCRIPT

echo "Smoke test passed"
