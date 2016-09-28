# Running a Puppet Server on Kubernetes

Using the Puppet-in-Docker images it's possible to run a Puppet Server
on a Kubernetes cluster. Kubernetes has lots of features, so the
following is just a hello world style example. For production usage
you'd likely want to look at persistant volumes, integrating with r10k,
running multiple replicas, etc.


## Getting a Kubernetes cluster

The following example should work with any Kubernetes install but I'm
going to be using [Google Container Engine](https://cloud.google.com/container-engine/)
as it's quick and simple to spin up a new cluster from the command
line. You'll first need a Google Cloud account and to install the
`gcloud` tools. You can sign up for a [free
trial](https://console.cloud.google.com/freetrial) if you don't already
have an account.

The following commands should create a new cluster called `puppet` and
then download the credentials to your local machine.

```
gcloud container clusters create puppet
gcloud container clusters get-credentials puppet
```


## Launching a Puppet Server

In order to luanch a Puppet Server using the `puppet/puppetserver-standalone` image we'll
need a Kubernetes Service and a Deployment. We could write those by hand
but it's also possible to generate the requireed configurations from a
Docker Compose file. For this we'll use [Kompose](https://github.com/skippbox/kompose).

With Kompose installed we simply need to run the following command to
launch our Puppet Server.

```
kompose up
```

If you'd like to see the generated Kubernetes configuration files you
can run the following command:

```
kompose convert
```

This should generate a `puppet-service.json` file along with a
`puppet-deployment.json` file in the local directory.

We're going to test out our Puppet Server from out local machine so
we'll need to expose it externally outside our cluster.

```
kubectl expose service puppet --port=8140 --target-port=8140 --name=puppet-external --type=LoadBalancer
```

We can watch the new service launch and then add an external load
balancer. Watch for the `EXTERNAL_IP` to be populated, we'll need that
later.

```
kubectl get service puppet-external --watch
NAME              CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
puppet-external   10.107.245.142   <pending>     8140/TCP   40s
...
puppet-external   10.107.245.142   123.456.78.91   8140/TCP   54s
```

## Add some sample Puppet content

To make the demo more interesting we'll upload some sample Puppet
content. We have to jump through a few hoops to do so, at least until
the [copy command is added to
Kubernetes](https://github.com/kubernetes/kubernetes/issues/13776).
First we need to grab the pod name.

```
kubectl get pods
NAME                              READY     STATUS    RESTARTS   AGE
puppet-2364724927-g4dj2           1/1       Running   0          19m
```

Then we'll upload the local `code` directory to the pod. Note that your
pod name will be different and need replacing in the following commands.

```
tar -cz code . | kubectl exec -i puppet-2364724927-g4dj2 -- tar -xz .
```

With that uploaded lets launch a shell on that pod:

```
kubectl exec -it puppet-2364724927-g4dj2 bash
```

Now on the pod we want to copy the Puppet code into the relevant place.
We're doing all of this by hand for this demo, but you could also
utilise r10k or create images containing your Puppet code and have them
mounted into the Puppet Server.

```
cp -r code/* /etc/puppetlabs/code/
```


## Running an agent

With that all set up lets run a sample agent. This could be any Puppet
agent on any machine you have available for testing. For for
simpplicities sake I'm going to use one of the other Puppet-in-Docker
images. Remember you're running this command locally and will need
Docker installed. You'll also need to swap the IP address below for the
one associated with the load balancer above.

```
docker run --add-host puppet:123.456.78.91 puppet/puppet-agent-alpine
```

You should see the above successfully connect to the master and apply
the code we uploaded to the Puppet Server. If you'd like to check it
really did work you can run some commands on the Pod. Log back in as
shown above using `kubectl exec` and try the following commands:

```
puppet cert list -a
ls /opt/puppetlabs/server/data/puppetserver/reports
```

You should see a signed certificate for the agent or agents and you
should see some reports in the reports folder.


## Cleaning up

Once you're done with the demo it's sensible to terminate the resources
as otherwise you'll end up paying for them to keep running. You can
remove the Kubernetes resources with the following commands:

```
kompose down
kubectl delete services puppet-external
```

If you want to clean up the entire Kubernetes cluster on GKE then you
can also run.

```
gcloud container clusters delete puppet
```
