# Puppet at runtime with Puppet-in-Docker

It can sometimes be useful to have access to Puppet in the context of a
running container. But you might not want to have all of the Puppet
software installed into all of your containers. Luckily Docker provides
a solution to this problem with
[Volumes](https://docs.docker.com/engine/userguide/containers/dockervolumes/).

Volumes allow for directories from one container to be mounted into
another at runtime. In the context of Puppet that means we can make the
Puppet software available to any container we like by mounting the
`/opt/puppetlabs` directory (which contains Puppet and all it's
dependencies due to the all-in-one packaging). Here is a simple example:

First run a puppet-agent container. This will terminate once the command
has run, just outputting the Puppet version, but the volume will persist.

```
docker run --name puppet-agent -v /opt/puppetlabs puppet/puppet-agent-ubuntu --version
```

With that volume in place we can use it in any other containers via the
handy `--volumes-from` command.

```
docker run --volumes-from=puppet-agent ubuntu /opt/puppetlabs/bin/puppet resource package tar --param provider
package { 'tar':
  ensure   => '1.27.1-1',
  provider => 'apt',
}
```

Note the name of the original container (which contains Puppet) is used
in the `volumes-from` argument for this container. To prove we're really
adding Puppet at runtime, if we run without mounting the volume:

```
docker run ubuntu /opt/puppetlabs/bin/puppet resource package
docker: Error response from daemon: Container command '/opt/puppetlabs/bin/puppet' not found or does not exist..
```

We can also mount the Puppet software into other suitable operating
systems and it should do the right thing. For instance here we mount
Puppet into a `CentOS` container.

```
docker run --volumes-from=puppet-agent centos /opt/puppetlabs/bin/puppet resource package tar --param provider
package { 'tar':
  ensure   => '2:1.26-29.el7',
  provider => 'yum',
}
```

The examples here demonstrate a simple _hello world_ using Puppet
resource. But this approach can be used to run all the available Puppet
commands, whcich opens up a number of interesting possibilities. Do let
us know if you use this capability and what you do with it.
