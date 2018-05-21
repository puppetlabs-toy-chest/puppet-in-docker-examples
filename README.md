# Puppet-in-Docker examples

[Puppet-in-Docker](https://github.com/puppetlabs/puppet-in-docker)
provides a series of Docker images containing Puppet software. This
repository builds on those images with various examples, from running
Puppet on container-centric operating systems to building a full Puppet
stack ontop of a container scheduler.

So far we have the following demos:

* [PhotonOS](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/photonos) - run Puppet on a VMware PhotonOS host
* [Atomic](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/atomic) - run Puppet on a CentOS Atomic host
* [CoreOS](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/coreos) - run Puppet on CoreOS
* [Docker compose](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/compose) - standup a Puppet Server stack using Compose
* [Puppet at runtime](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/puppet-at-runtime) - use Puppet inside a new container without it being part of the original image
* [Hyper_](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/hyper_) - run Puppet on the Hyper_ container platform
* [Kubernetes](https://github.com/puppetlabs/puppet-in-docker-examples/tree/master/kubernetes) - an example of running a Puppet Server on Google Container Engine

If you have suggestions for further examples, or if you've put something
interesting together using Puppet-in-Docker, let us know by opening an
issue or a pull request.

# Maintainers

This repository is maintained by the Puppet, Inc. release engineering team <release@puppet.com>

Individual examples may have separate maintainers as mentioned in the
relevant READMEs.

# Issues

File issues and feature requests in the [Community Package Repository (CPR) project](https://tickets.puppet.com/browse/CPR) with the 'Container' component.
