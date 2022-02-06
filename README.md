# Ansible Docker container image

The goal of this project is to provide an up-to-date version of [Ansible](https://www.ansible.com/) that people can run in a ([Docker](https://www.docker.com/)) container.

This project was created for [spantaleev/matrix-docker-ansible-deploy](https://github.com/spantaleev/matrix-docker-ansible-deploy) (see [Using Ansible via Docker](https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/ansible.md#using-ansible-via-docker)).


## Building

If you need to build it yourself, instead of using the [devture/ansible](https://hub.docker.com/r/devture/ansible/) image that we publish to Docker Hub.

```bash
docker build -t devture/ansible:latest -f Dockerfile .
```

## Usage


### Usage against a remote SSH host

If you can connect to the remote server using SSH, use the following command:

```bash
cd /some/ansible-project

docker run -it --rm \
-w /work \
-v `pwd`:/work \
-v $HOME/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
--entrypoint=/bin/sh \
devture/ansible:latest
```

You can execute `ansible-playbook` commands as per normal now.


### Usage against the same host

If you'd like to run Ansible in a container on the server, and then target that same server from inside the container, use this:

```bash
cd /some/ansible-project

docker run -it --rm \
--privileged \
--pid=host \
-w /work \
-v `pwd`:/work \
--entrypoint=/bin/sh \
devture/ansible:latest
```

When invoking the `ansible-playbook` commands, ensure that:

- you *either* add `--connection=community.docker.nsenter` to the command (e.g. `ansible-playbook --connection=community.docker.nsenter ...`)

- *or* that you've set `ansible_connection=community.docker.nsenter` for each host that needs it in your Ansible `hosts` file
