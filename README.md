# Ansible Image
Ansible Docker Image


[![](https://images.microbadger.com/badges/image/intelygenz/ansible.svg)](https://microbadger.com/images/intelygenz/ansible "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/intelygenz/ansible.svg)](https://microbadger.com/images/intelygenz/ansible "Get your own version badge on microbadger.com")



## Supported tags and respective Dockerfile links

All versions are generated using a unique [Dockerfile](https://github.com/intelygenz/ansible-image/blob/master/Dockerfile) what is located at [Intelygenz's Ansible Image GitHub repository](https://github.com/intelygenz/ansible-image)

* [2.5](https://github.com/intelygenz/ansible-image/releases/tag/2.5): [Dockerfile](https://github.com/intelygenz/ansible-image/blob/master/Dockerfile)
* [2.5.0](https://github.com/intelygenz/ansible-image/releases/tag/2.5.0): [Dockerfile](https://github.com/intelygenz/ansible-image/blob/master/Dockerfile)
* [2.5.14](https://github.com/intelygenz/ansible-image/releases/tag/2.5.14): [Dockerfile](https://github.com/intelygenz/ansible-image/blob/master/Dockerfile)
* [2.6.0](https://github.com/intelygenz/ansible-image/releases/tag/2.6.0): [Dockerfile](https://github.com/intelygenz/ansible-image/blob/master/Dockerfile)


## Getting Started

There are no official Ansible images based on the alpine docker image. So we opted to create our own.

You can build this docker image locally by following the instructions:

### Prerequisites
As you can guess, you need to have `docker` and `git` installed on your computer. Once installed we can proceed to download the code and build the image.

### Building
If you've ever built a docker image, this is nothing special.

```bash
git clone https://github.com/intelygenz/ansible-image.git && cd ansible-image
docker build --build-arg ANSIBLE_VERSION=2.5.0 -t ansible-image:local .
```

Once the image is built, we will have in our premises an image whose name will be: `ansible-image:local`.

**Take note that to build the Ansible docker image the version of ansible to be built is passed to it as a building argument.**

### Running the tests
We can test run an Ansible dummy command to verify that the image has been successfully constructed.
```bash
docker run --rm ansible-image:local ansible --version
ansible 2.5.0
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/site-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.6.4 (default, Jan 10 2018, 05:26:33) [GCC 5.3.0]
```

## Usage

Provide a valid `ansible.cfg` file is necessary in order to use the docker image. All files needed must be included in a volume ounted at the `/ansible` directory inside the container.


### Invocation examples

Given the following `ansible.cfg`:

```ini
[defaults]

inventory = hosts
remote_user = user
host_key_checking = True

[ssh_connection]

ssh_args = "-o StrictHostKeyChecking=yes -o UserKnownHostsFile=./path/to/known_hosts"
```
This file sets host key checking to true and indicates a path to a valida *known_hosts* file.

Execute Ansible: 

```bash
$ docker run --rm -v $PWD:/ansible ansible:2.7.5 ansible -m setup <my_host>
```

The example above assumes that all ansible config, inventory and ssh needed files exist in the current working dir ($PWD), wich will be mounted inside the container at `/ansible` mount point.

Notice that provide a valid `known_hosts` file is mandatory in order to use ansible option `-k`, `--ask-pass` because *sshpass* is uncompatible with manual host key checking when `host_key_checking` is set to **True**.

The use of `-it` options are necessary when a ssh key passphrase is asked.

```bash
$ docker run -it --rm -v $PWD:/ansible ansible-image:2.7.5 ansible -m setup <my_host>
```

Another example. This time with no host key checking:

```ini
[defaults]

inventory = hosts
remote_user = user
host_key_checking = False
ask_pass = True
```

Execute Ansible:

```bash
docker run -it --rm -v $PWD:/ansible ansible-image:2.7.5 ansible -m setup <my_host>
```

You can also specify Ansible options through command line.

```bash
docker run -it --rm -v $PWD:/ansible ansible-image:2.7.5 ansible -i hosts -u user -m setup -k <my_host>
```

### Executing Ansible paybooks

Like the examples above, all Ansible config files, ssh needed files and playbook structure files must be mounted inside the container at `/ansible` mount point. So, given the following directory structure:

```
- ansible.cfg
- hosts
- playbook.yml
- roles
  - role1
  - role2
  - roleN
- ssh
  - known_hosts
  - id_rsa
```

And given the following `ansible.cfg`

```ini
[defaults]

inventory = hosts
remote_user = user
host_key_checking = True
private_key_file = ssh/id_rsa
roles_path = roles

[ssh_connection]

ssh_args = "-o StrictHostKeyChecking=yes -o UserKnownHostsFile=./ssh/known_hosts"
```

Execute `ansible-playbook`:

```bash
$ docker run -v $PWD:/ansible ansible-image:2.7.5 ansible-playbook playbook.yml
```
