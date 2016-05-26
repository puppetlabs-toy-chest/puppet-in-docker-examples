# Puppet-in-Docker and PhotonOS

[PhotonOS](https://vmware.github.io/photon/) is "a minimal Linux container
host, optimized to run on VMware platforms." It's part of the VMware
effort around vSphere Integrated Containers (VIC) which aims to make
running containers a first class citizen on vSphere. It does this wrapping
the containers in PhotonOS which, when running in vSphere, exposes information
about the container to the standard vSphere management tools in the same way
as VMware tools does for VM operations.

This piece from [The New
Stack](http://thenewstack.io/vmwares-photon-platform-and-how-it-treats-containers/)
provides a useful introduction.

Puppet-in-Docker provides a simple way of running Puppet software on
Photon. This simple example demonstrates running the standalone Puppet
Server, as well as Puppet anf Facter, on Photon. It uses Vagrant, and
the official `vmware/photon` Vagrant box for an easy local demo.

## Example

The following assumes you have [Vagrant](https://vagrantup.com)
installed. If you already have a PhotonOS instance then you can run the
commands by hand if you prefer.

Either checkout this repository and enter this directory, or simply
download the `Vagrantfile` in this diretory to your machine.

```
vagrant up
```

This will first download the `vmware/photon` box. Once downloaded, a VM
will be started, and once up and running the Docker daemon will be
aenbled and started on the running VM. With that out of the way the
provisioner will launch three Puppet-in-Docker containers:

1. A persistent Puppet Server running on PhotonOS
2. Facter, dumping the facts from the PhotonOS host
3. A onetime Puppet agent run pointing at the Puppet Server

You can also rerun the facter and puppet commands from outside the VM
like so:

```
vagrant provision --provision-with facter
vagrant provision --provision-with puppet
```
