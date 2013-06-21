mcollective-docker-agent
========================

##What##

This is a simple MCollective Agent for the Docker API. It uses [geku/docker-client](https://github.com/geku/docker-client) to access the docker API. 
On the other end it exposes the services as actions within the mcollective agent. An mcollective application allows for easy
rpc calls on multiple container hosts.

##Why##
 
Maintaining a large container-based setup can become hard. A client would have to connect to individual docker daemons, 
which does not scale very well. Using this agent, a client can have access to docker daemons on multiple hosts/vms,
controlling all of them in parallel. 

For more information on MCollective, see this [introduction](http://puppetlabs.com/mcollective/introduction/).

##Dependencies##

 * MCollective (>=1.3.2) from [puppetlabs](http://puppetlabs.com/puppet/puppet-open-source/), at least mcollective-server on the host side
 * [Docker](http://www.docker.io/)
 * The docker-client from (https://github.com/geku/docker-client)

##Installation##

Clone this repo. The contents of agent/ and appliation/ must be copied to the mcollective library directory, 
which is referenced in /etc/mcollective/server.cfg (and /etc/mcollective/client.cfg):

````
$ MCOBASEDIR=$(cat /etc/mcollective/server.cfg | awk -e '/^libdir/ { print $3 }')/mcollective
$ cp agent/docker* $MCOBASEDIR/agent/
$ cp application/docker* $MCOBASEDIR/application/
$ service mcollective restart
````

You will need a functional mcollective setup (with server,clients and message bus) and a functional docker installation.
Please refer to the sites mentioned above for setup instructions.

##Usage##

The mcollective client application covers a number of use cases provided also by the docker console client. It execute them on 
multiple servers within the collective and returns the result. The output is similar to the docker command but includes the
server name in the first column.

####Show running containers####
````
$ mco docker ps

 * [ ============================================================> ] 1 / 1

SERVER              ID                  IMAGE               COMMAND             CREATED             STATUS              PORTS
ubu1304             98c5f2f03e14        busybox:latest      /bin/sh             1371815051          Up 2 hours
ubu1304             468f5d70bcb7        busybox:latest      /bin/sh             1371815051          Up 2 hours
...

Finished processing 1 / 1 hosts in 71.37 ms
````

####Show *all* containers (including non-running), but limit output to 20 items ####
````
$ mco docker ps --all --limit=20
````

####List containers created before or since other containers####
````
$ mco docker ps --all --beforeId=98c5f2f03e14
$ mco docker ps --all --sinceId=98c5f2f03e14
````

####Show images####
````
$ mco docker images
````

##TODOs##
  * gemspec
  * rake task
  * implement commands on application client
  * implement more actions 

