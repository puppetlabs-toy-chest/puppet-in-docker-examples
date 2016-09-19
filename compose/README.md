# Puppet-in-Docker with Docker Compose

[Docker Compose](https://docs.docker.com/compose/) is a tool for defining and
running multi-container Docker applications. With compose you define a
set of containers, along with their relationships, in a YAML file. And
then use the `docker-compose` CLI to launch and manage them.

For this example we've provided a compose file using the version 2
schema. This means you will need at least Docker Engine 1.10 and Compose
1.6.

## Running the server

The example launches a stack running Puppet Server, PuppetDB, a
PostgresDB container for PuppetDB and the open source dashboards
Puppetboard and Puppet Explorer. See the `docker-compose.yml` file for
details.

Run `docker-compose up` to launch the containers. Note that you'll see
lots of output as the various software launches in parallel.

```
$ docker-compose up
Creating compose_puppetboard_1
Creating postgres
Creating puppet
Creating compose_puppetexplorer_1
...
```

One the output from compose stops, in another terminal confirm you have the
containers up and running.

```
$ docker ps                                                                                                                                                                                                                                                             ~
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                              NAMES
7af731797a95        puppet/puppetexplorer      "/usr/bin/caddy"         2 minutes ago       Up 2 minutes        0.0.0.0:32828->80/tcp                              compose_puppetexplorer_1
8f8aecd2cc69        puppet/puppetserver        "/opt/puppetlabs/bin/"   2 minutes ago       Up 2 minutes        0.0.0.0:32827->8140/tcp                            puppet
1fefb0ea22ff        puppet/puppetdb-postgres   "/docker-entrypoint.s"   2 minutes ago       Up 2 minutes        5432/tcp                                           postgres
910002aa3e6a        puppet/puppetboard         "/usr/bin/gunicorn -b"   2 minutes ago       Up 2 minutes        0.0.0.0:32824->8000/tcp                            compose_puppetboard_1
78bfd7967680        puppet/puppetdb            "dumb-init /docker-en"   2 minutes ago       Up 2 minutes        0.0.0.0:32826->8080/tcp, 0.0.0.0:32825->8081/tcp   compose_puppetdb_1
```

Note the port number for the puppetexplorer container, in my case `32828`. If
you're running docker locally you should be able to access the dashboard
on `0.0.0.0:32824` (your port will likely vary). If you're running
`docker-machine` then you can run `docker-machine ip` to determine the
correct IP address. So far the dashboard should be empty, we haven't run
any agents yet. Let's do that now.


## Running ephemeral agents

You could connect any agents to the Puppet infrastructure launched above
but for demonstration purposes we're just going to launch a few ephemeral
puppet agents in Docker containers. These aren't useful in most sense,
the container will run, receive instructions from Puppet and then disappear.
But they are useful for testing and demonstration purposes.

Note that compose automatically creates a default network which we need to
connect our containers to in order for them to find the Puppet Server.

Let's run up a few alpine agents. Run the following command a few times.

```
docker run --net compose_default puppet/puppet-agent-alpine
```

And then run some Ubuntu based agents. Again run the command a couple
of times to populate the database.

```
docker run --net compose_default puppet/puppet-agent-ubuntu
```

Now access the dashboard described above again. You should have some data
to explore.

## Exploring PuppetDB data

PuppetDB also exposes a dashboard, showing various operational metrics,
as well as [an API](https://docs.puppet.com/puppetdb/latest/api/) for
accessing all the collected resource data. You can find the port for the
dashboard using `docker ps` described above. The `docker port` command can
also be useful.

```
$ docker port compose_puppetdb_1
8080/tcp -> 0.0.0.0:32826
8081/tcp -> 0.0.0.0:32825
```

With that port in hand, and the ip address of the machine running docker,
you can query the PuppetDB API.

```
$ curl -s -X GET http://192.168.99.100:32826/pdb/query/v4 --data-urlencode 'query=nodes {}' | jq
{
    "deactivated": null,
    "latest_report_hash": "f8332ac22e0abf6a51571fae6b57b2a881f207fe",
    "facts_environment": "production",
    "cached_catalog_status": "not_used",
    "report_environment": "production",
    "catalog_environment": "production",
    "facts_timestamp": "2016-05-27T12:47:04.495Z",
    "latest_report_noop": false,
    "expired": null,
    "report_timestamp": "2016-05-27T12:47:04.144Z",
    "certname": "a9efc038b3ca",
    "catalog_timestamp": "2016-05-27T12:47:05.038Z",
    "latest_report_status": "changed"
  },
  {
    "deactivated": null,
    "latest_report_hash": "d273124e1e74708272228ac4465f6f1923100db7",
    "facts_environment": "production",
    "cached_catalog_status": "not_used",
    "report_environment": "production",
    "catalog_environment": "production",
    "facts_timestamp": "2016-05-27T12:47:37.543Z",
    "latest_report_noop": false,
    "expired": null,
    "report_timestamp": "2016-05-27T12:47:36.959Z",
    "certname": "5a4cbf61e790",
    "catalog_timestamp": "2016-05-27T12:47:38.050Z",
    "latest_report_status": "changed"
  }
]
```

Here I'm issuing a [PQL](https://docs.puppet.com/puppetdb/latest/api/query/v4/pql.html)
query for all nodes. I'm parsing it through [jq](https://stedolan.github.io/jq/) for
nicer formatting.

PuppetDB stores a great deal of information, and PQL and the API provides a
powerful way of accessing it. The Puppet-in-Docker setup makes for a great
experimental test bed for building atop that capability.

## Troubleshooting

In case you see errors like the this on the puppet container:

```
ERROR [puppetserver] Puppet Failed to execute '/pdb/cmd/v1?checksum=eeb40197db6a4ac3d8bce09778388cf7a812a621&version=5&certname=puppetdb.local&command=replace_facts' on at least 1 of the following 'server_urls': https://puppetdb:8081
ERROR [c.p.h.c.i.PersistentSyncHttpClient] Error executing http request
 java.net.ConnectException: Connection refused
```

Try to uncomment the following lines in the definition of the puppet service in the `docker-compose.yaml` file:

```
environment:
  - PUPPETDB_SERVER_URLS=https://puppetdb.local:8081
links:
  - puppetdb:puppetdb.local
```
