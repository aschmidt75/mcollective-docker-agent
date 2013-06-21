mcollective-docker-agent
========================

##What##

This is a simple MCollective Agent for the Docker API. It uses the [geku/docker-client](https://github.com/geku/docker-client) to access the docker API. 
On the other end it exposes the docker api services as actions within the mcollective agent.

##Why##
 
Maintaining a large container-based setup can become hard. A client would have to connect to individual docker daemons, 
which does not scale very well. Using the Docker agent, a client can have access to docker daemons on multiple hosts/vms,
controlling all of them in parallel. 

For more information on MCollective, see this [introduction](http://puppetlabs.com/mcollective/introduction/).

##Dependencies##

 * MCollective (>=1.3.2) from [puppetlabs](http://puppetlabs.com/puppet/puppet-open-source/)
 * [Docker](http://www.docker.io/)
 * The docker-client from (https://github.com/geku/docker-client)

##Installation##

Clone this repo. The contents of agent/ and appliation/ must be copied to the mcollective library directory, 
which is referenced in /etc/mcollective/server.cfg (and /etc/mcollective/client.cfg)

