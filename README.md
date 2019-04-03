# Ansible Docker container image

The goal of this project is to provide an up-to-date version of [Ansible](https://www.ansible.com/) that people can run in a ([Docker](https://www.docker.com/)) container.

This project was created for [spantaleev/matrix-docker-ansible-deploy](https://github.com/spantaleev/matrix-docker-ansible-deploy) (see [Using Ansible via Docker](https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/docs/ansible.md#using-ansible-via-docker)).


## Building

If you need to build it yourself, instead of using the [devture/ansible](https://hub.docker.com/r/devture/ansible/) image that we publish to Docker Hub.

```bash
docker build -t devture/ansible:latest -f Dockerfile .
```

## Using

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
