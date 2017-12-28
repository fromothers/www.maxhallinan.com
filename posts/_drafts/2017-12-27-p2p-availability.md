---
layout: post
title: "Silos of Subjectivity"
subtitle: "A dilemma of availability on peer-to-peer networks"
---

Many peer-to-peer networks identify a resource by _what_ it is and not _where_ 
it is.
This is called content addressing.
A content-addressed resource is not tied to a single host.
Any node that downloads the resource is capable of hosting it.
Multiple nodes can host the same data simultaneously.
If one host goes offline, the resource is still accessible on other hosts.
The resource is available until all hosts go offline and the likelihood of this
happening decreases as the number of hosts grow.
Meanwhile, the address of the resource remains the same.
Links to the resource do not break when the location of the resource changes.

For these reasons among others, peer-to-peer networks have recently been 
celebrated as a remedy to the "information silos" and "walled gardens" of the
contemporary world wide web. 
These terms broadly describe conditions on a client-server network where data is 
stored in a closed system and access to the data is controlled.
Platforms like Facebook and publicly-funded research published behind a 
paywall are common examples.
In both cases, the data is not directly exposed to the public.
The public must go through a controlling authority to access the data and access
occurs under terms set by that authority.
This control is possible because client-server networks use the location of a 
host to identify a resource.
Location addressing ties a resource to its host and whoever controls the host 
controls the data.
This kind of control is harder to achieve on a peer-to-peer network because 
the data is not identified by or tied to a location.
If a host tries to control access to the data, a client can route around this 
host and access the same data at another location.
The intent is to embed the ideal of openness in the network architecture by 
making it much harder (perhaps impossible) to own publicly accessed data.

Better availability on peer-to-peer networks does not guarantee 
availability.
Given a valid address, a client can wait eternally for a host to connect to the 
network.
In my experience with Bittorrent, this is not uncommon.
I rarely pirate movies because the movies available to download are often not 
the movies I want to watch.
A torrent for a Canadian documentary is useless if I can only locate peers 
seeding the latest Hollywood blockbuster.
What I actually watch is often a compromise between my tastes and what is 
available to download.
That is because resources in greater demand are more likely to have multiple 
hosts.
As the number of hosts grows in some rough proportion to the demand, the 
popular resources generally enjoy greater availability.

My primary concern is that this effect could distort the peer-to-peer web 
through a process that resembles natural selection: available resources will be 
those that have proven their fitness, either organically through propagation to 
a large number of peers or artificially, by location on a small number of 
resilient hosts, e.g. a VPS.
Inevitably, the availability of data will be decided to some degree by patterns 
of selective downloading and hosting. 
Some data will be selected simply because it is the easiest to access, just as
I have often chosen to pirate movies that are fast to download instead of movies
that interest me.
When I choose to seed these movies after downloading, as I routinely do, then 
the movie has propagated to another host simply because it was the most 
available to begin with.
As the pattern self-reinforces, the network can become weighted towards and 
amplify the bias of its users, especially the bias that informed the earliest 
selections.
However this compares to the client-server web of today, it is inconsistent
with the egalitarian ideal of free information that the peer-to-peer web is 
intended to manifest.
Like the virulent echo chambers that have emerged on social networks, a web 
based on such a network could become more a tool for confirming bias than 
for deepening understanding.
If the peer-to-peer web does not take steps to ensure general rather than 
selective availability, the silos of information will only be replaced with 
silos of subjectivity.
