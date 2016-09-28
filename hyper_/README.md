# Running Puppet on Hyper_

[Hyper_](https://hyper.sh/) is pretty much the simplest way of running
your containers in the cloud. To try out the following example you'll
need a Hyper_ account and to have installed and configured the
hyper command line tools. See the [getting
started](https://docs.hyper.sh/GettingStarted/index.html) guide.

## Launching Puppet with Compose

For this demo we're going to launch a series of containers, specifically
a Puppet Server, PuppetDB (and PostgreSQL database) and two dashboards.
See the `docker-compose.yml` file for the full details.

```
hyper compose up
```

The above command will take a short time to launch everything and will
remain in the foreground. If you prefer you can run with the `--detach`
option and move it to the background.

Containers launched in Hyper_ can communicate with each other using a
private network but in order to access them from outside we need to
attach an IP address. Lets grab a couple of floating IPs.

```
hyper fip allocate 2
```

For the next part you'll need to know the IP addresses you have been
allocated. Run the following command to get them. Note as well that the
IPs are currently not attached to any containers.

```
hyper fip ls
Floating IP         Container
123.456.78.91
198.765.43.21
```

Now we can attach the IPs you've been allocated to the two dashboards
mentioned above. Replace the IP addresses below with the real ones you
get from the `fip ls` command.

```
hyper fip attach 123.456.78.91 hyper-puppetexplorer-1
hyper fip attach 198.765.43.21 hyper-puppetboard-1
```

And finally lets run a few agents just to populate our PuppetDB with
data. In a real world usecase these could just be normal agents, running
on Hyper_ or running elsewhere. 

```
hyper run puppet/puppet-agent
hyper run puppet/puppet-agent-alpine
hyper run puppet/puppet-agent-centos
hyper run puppet/puppet-agent-debian
```

You should be able to visit the two IP addresses you recieved above and
see the dashboards, with data from the dummy agent runs.


## Next steps

This is obviously a hello world example but is hopefully a good starting
point for further experimentation. Obvious next steps might include:

* Exposing the Puppet Server to infrastructure outside Hyper_ in order to
  manage any types of infrastructure
* Utilising [Hyper_ Security Groups](https://docs.hyper.sh/Feature/sg.html) to
  restrict access the dashboards or Puppet Server
* Mounting your Puppet code onto the Master, or using r10k to
  automatically sync code from a control repository
* Adding a mechanims for easily scaling up and down the size of the Puppet
  Server and PuppetDB containers


## Cleaning up

Once you've done experimenting it's important to shut everything down.
Containers left running in Hyper_ will cost you money. First either
exit the original `hyper compose up` run or type the following:

```
hyper compose down
```

You also probably want to remove any left over stopped containers. Note
that this will remove everything so be careful if you're doing any more
that just this demo.

```
hyper ps -a -q | xargs hyper rm -f
```
