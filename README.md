# Ansible Docker container image

The goal of this project is to provide an up-to-date version of [Ansible](https://www.ansible.com/) and [agru](https://github.com/etkecc/agru) that people can run in a ([Docker](https://www.docker.com/)) container.

This project was created for [spantaleev/matrix-docker-ansible-deploy](https://github.com/spantaleev/matrix-docker-ansible-deploy) (see [Using Ansible via Docker](https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/ansible.md#using-ansible-via-docker)).


## Building

If you need to build it yourself, instead of using the [ghcr.io/devture/ansible](https://github.com/devture/docker-ansible/pkgs/container/ansible) image that we publish to Docker Hub.

```bash
docker build -t ghcr.io/devture/ansible:latest -f Dockerfile .
```

## Usage


### Usage against a remote SSH host

If you can connect to the remote server using SSH, use the following command:

```bash
cd /some/ansible-project

docker run
-it \
--rm \
-w /work \
--mount type=bind,src=`pwd`,dst=/work \
--mount type=bind,src$HOME/.ssh/id_ed25519,dst=/root/.ssh/id_ed25519,ro \
--entrypoint=/bin/sh \
ghcr.io/devture/ansible:latest
```

You can execute `ansible-playbook` commands as per normal now.


### Usage against the same host

If you'd like to run Ansible in a container on the server, and then target that same server from inside the container, use this:

```bash
cd /some/ansible-project

docker run
-it \
--rm \
--privileged \
--pid=host \
-w /work \
--mount type=bind,src=`pwd`,dst=/work \
--entrypoint=/bin/sh \
ghcr.io/devture/ansible:latest
```

When invoking the `ansible-playbook` commands, ensure that:

- you *either* add `--connection=community.docker.nsenter` to the command (e.g. `ansible-playbook --connection=community.docker.nsenter ...`)

- *or* that you've set `ansible_connection=community.docker.nsenter` for each host that needs it in your Ansible `hosts` file


## Interactive SSH prompts

Since Ansible 2.21, forked workers call `setsid()` and thus lose the controlling terminal. SSH cannot open `/dev/tty` anymore, so it can no longer ask you to confirm an unknown host key or prompt you for the passphrase of an SSH key. It fails with `Host key verification failed` instead.

This image is meant to be used interactively (note the `-it` in the `docker run` invocations above) and its container is thrown away after each use, so a host key confirmed in a previous run would not be remembered anyway. We therefore set `ANSIBLE_WORKER_SESSION_ISOLATION=False` in the image, which restores the previous behavior.

If you would rather have the Ansible default, pass `-e ANSIBLE_WORKER_SESSION_ISOLATION=True` to `docker run`.
