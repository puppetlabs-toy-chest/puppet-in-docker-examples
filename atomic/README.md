# Puppet-in-Docker for Atomic Host

Atomic Host is part of [Red Hat's Project
Atomic](http://www.projectatomic.io/download/). This is a lightweight
operating system that has been assembled out of upstream RPM content. It
is designed to run applications in Docker containers.

Puppet-in-Docker provides a simple way of running Puppet software on
Atomic. This simple example demonstrates running the standalone Puppet
Server, as well as Puppet and Facter, on CentOS Atomic. It uses Vagrant, and
the official `centos/atomic-host` Vagrant box for an easy local demo.

## Example

The following assumes you have [Vagrant](https://vagrantup.com)
installed. If you already have an Atomic host then you can run the
commands by hand if you prefer.

Either checkout this repository and enter this directory, or simply
download the `Vagrantfile` in this diretory to your machine.

```
vagrant up
```

This will first download the `centos/atomic-host` box. Once downloaded, a VM
will be started. Docker should already be running on the host. With that out
of the way the provisioner will launch three Puppet-in-Docker containers:

1. A persistent Puppet Server running on Atomic
2. Facter, dumping the facts from the Atomic host
3. A onetime Puppet agent run pointing at the local Puppet Server

You can also rerun the facter and puppet commands from outside the VM
like so:

```
vagrant provision --provision-with facter
vagrant provision --provision-with puppet
```

This is intended as a proof-of-concept only. However this should be
enaough to get an enthusiastic early-adopter started. It would be
relatively simple to built on this with init scripts for the containers
or to hook the agent instead into a Puppet Server or Puppet Enterprise
installation running elsewhere. The exact list of mounted volumes may
also vary depending on your particular usecase.

Atomic also uses the `atomic` CLI tool which could be used to launch a
container, based on the value of the `INSTALL` label. This would be a
nice addition to the Puppet-in-Docker containers.
