---
layout: post
title: "The Silo of Obscurity: an Availability Dilemma on p2p Networks"
---

Content-addressed, peer-to-peer networks are an improvement on 
location-addressed server-client networks.

On a location-addressed network, a resource is tied to a host. If the host goes 
offline, the resource is unavailable.

On a content-addressed network, a resource can be hosted by multiple nodes
simultaneously.
If one host goes offline, the resource is still available from other hosts.

The baseline for hosting is roughly equivalent for client-server and 
peer-to-peer networks: a single server or a single node that hosts the resource.

A less obvious is how the popularity of or demand for a resource influences it's
availability.

Popular resources are more likely to be available.

It is not uncommon for unpopular resources to be unavailable.

Demand-based availability distorts the network.

It is important for unpopular resources to have stable availability.

There are a number of ways to improve the availability of obscure or unpopular
data:

- Social norm of volunteerism, like the Tor network.
- Issue-based initiatives/organizations like the Internet Archive.
- Incentivize people to host unpopular content.

The popularity of a resource promotes the availability of that resource on a
peer-to-peer network.
Popularity is not the only factor that determines availability.
Reliable availability is possible for any resource hosted by a node with a 
stable network connection.
The baseline for hosting on a peer-to-peer network is no higher than it is for
hosting on an HTTP network.
But availability on server-client networks is limited by the coupling of the 
resource and its network location.

But content-addressing, when resources are identified by _what_ they are 
instead of _where_ they are, makes it possible to locate a 
single logical resource simultaneously in multiple network locations. 
When a resource is hosted by multiple nodes, the availability of the resource
is only effected when all hosts go offline.
The likelihood that all hosts go offline at the same time decreases as the 
number of hosts grow.
Content-addressing promotes availability for all resources but popular resources 
are more likely to be replicated.
If the number of hosts grow in proportion to the popularity of the resource,
then popularity promotes availability. 

In this sense, peer-to-peer networks are less vulnerable to link rot than
networks like HTTP where a resource is tied to a single origin.
But better availability on a peer-to-peer network does not mean guaranteed
availability.
Given a valid address, one could still wait eternally for someone to seed the 
data.
In this sense, link rot on a peer-to-peer network is still a problem.
In my experience with BitTorrent, it is not an uncommon problem.
I rarely pirate movies because the movies available to download are frequently 
not the movies I want to watch.
When I pirate movies, what I end up watching is often a compromise between my 
tastes and what is available to download.
As a media pirate, I have nothing to say about torrents that are perpetually
lacking seeders.
When I got to the store to steal a wrench, I don't complain when the wrenches
are out of stock.
But I'm also someone who is interested in the possiblity that peer-to-peer
networks are a remedy to some (perhaps many) of the imperfections of http
networks.
As that person, I think it's worth considering the plight of the unpopular
resource on the peer-to-peer web.

