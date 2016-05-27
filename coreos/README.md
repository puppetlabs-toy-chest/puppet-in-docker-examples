# Puppet-in-Docker for CoreOS

[CoreOS](https://coreos.com/using-coreos/) is an operating system designed for
security, consistency, and reliability. Instead of installing packages via
yum or apt, CoreOS uses Linux containers to manage your services at a higher
level of abstraction. A single service's code and all dependencies are
packaged within a container that can be run on one or many CoreOS machines.

Puppet-in-Docker provides a simple way of running Puppet software on
CoreOS. This simple example demonstrates running the standalone Puppet
Server, as well as Puppet and Facter, on a CoreOS host. It uses Vagrant, and
the official stable channel Vagrant box for an easy local demo.

## Example

The following assumes you have [Vagrant](https://vagrantup.com)
installed. If you already have a PhotonOS instance then you can run the
commands by hand if you prefer.

Either checkout this repository and enter this directory, or simply
download the `Vagrantfile` in this diretory to your machine.

```
vagrant up
```

This will first download the relevant vagrant box. Once downloaded, a VM
will be started with Docker already running on the host.  With that out
of the way the provisioner will launch three Puppet-in-Docker containers:

1. A persistent Puppet Server running on CoreOS
2. Facter, dumping the facts from the CoreOS host
3. A onetime Puppet agent run pointing at the Puppet Server

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

A shout-out to [Paul Morgan](https://github.com/jumanjiman) from the
Puppet community who has a [similar project](https://github.com/jumanjiman),
including sample systemd service descriptions.
