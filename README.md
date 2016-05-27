# Puppet-in-Docker examples

[Puppet-in-Docker](https://github.com/puppetlabs/puppet-in-docker)
provides a series of Docker images containing Puppet software. This
repository builds on those images with various examples, from running
Puppet on container-centric operating systems to building a full Puppet
stack ontop of a container scheduler.

So far we have the following demos:

* [PhotonOS](photonos) - run Puppet on a VMware PhotonOS host
* [Atomic](atomic) - run Puppet on a CentOS Atomic host
* [CoreOS](coreos) - run Puppet on CoreOS
* [Docker compose](compose) - standup a Puppet Server stack using Compose

If you have suggestions for further examples, or if you've put something
interesting together using Puppet-in-Docker, let us know by opening an
issue or a pull request.

# Maintainers

This repository is maintained by: Gareth Rushgrove <gareth@puppet.com>.

Individual examples may have separate maintainers as mentioned in the
relevant README's.
