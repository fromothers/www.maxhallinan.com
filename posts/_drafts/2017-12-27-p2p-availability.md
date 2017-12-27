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

For these among other reasons, peer-to-peer networks have recently been 
celebrated as a solution to the "information silos" and "walled gardens" of the
contemporary world wide web. 
These terms broadly describe conditions on a client-server network where data is 
stored in a closed system and access to the data is controlled.
Platforms like Facebook and publicly-funded research published behind a 
paywall are common examples.
In both cases, the data is not directly exposed to the public.
The public must go through a controlling authority to access the data and access
occurs under terms set by that authority.
Client-server networks enable this control by using the location of a host to 
identify a resource.
The data is tied to the host and whoever controls the host controls the data.
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

My primary concern is that this effect could distort a peer-to-peer web through 
a process that resembles natural selection: available resources will be those 
that have proven their fitness, either organically through propagation to a 
large number of peers or artificially, by location on a small number of 
resilient hosts, e.g. a VPS.
When human subjectivity, expressed through the acts of downloading and hosting
some data and not other data, influences the availability of the data, then 
the network becomes weighted towards the bias of its users.
While this is no worse than the client-server web of today, it is inconsistent
with the egalitarian ideal of free information that the peer-to-peer web is 
intended to manifest.
Like the virulent echo chambers that have emerged on social networks, a web 
based on such a network could become more a tool for confirming bias than 
for deepening understanding.
The silos of information will only be replaced with silos of subjectivity.

I have no evidence that this could or will happen.
Nonetheless, I would like to explore approaches to this dilemma even if this 
dilemma is purely a straw man.
Doing so is an opportunity to think about what I desire for the peer-to-peer 
web.

The first approach is to develop a culture of dispassionate hosting, a 
community whose members volunteer to host low-availability data regardless of 
personal relevance.
I doubt the practicality of this approach.
A culture of detachment might eliminate powerful motivators, such as a feeling
of personal investment, that drive people to better the network.
Many successful peer-to-peer networks benefit from these motivators.
Some Bittorrent users seed data after downloading in the spirit of giving back.
Some Tor network community members, including myself, donate bandwidth to express 
a belief in the principles on which the network is founded.

Even if a culture of detachment is not an effective way to promote a free and 
open peer-to-peer web, other kinds of culture might be.
Karisa McElvy, a founder of the Dat peer-to-peer network, writes that the 
Dat community must cooperate to stabilize vulnerable data:

> Decentralization of data produces challenges though — just like a torrent, 
> data that is decentralized can go offline if there aren’t any stable and 
> trusted peers... To mitigate it, we invoke the human part of a commons — the 
> data will be commonly managed... When a dat becomes less healthy, the 
> community can be alerted and make sure the resource does not go down. 
> Decentralized tech and decentralized humans working together to use commons 
> methodology in practice.
>
> ["The Web of Commons"](https://blog.datproject.org/2017/09/21/dat-commons/)

Karisa's blog post and the accompanying talk note that technology alone cannot
achieve the aims of the network.
A collective sense of responsibility for the network is as necessary as the 
network itself for achieving those aims.

The original use case for the Dat network is sharing large scientific datasets.
I think it's reasonable to expect a scientific community to carefully maintain 
scientific data.
But I'm less confident that the general public can be relied on to donate 
storage and bandwidth to host something that is not collectively valued, e.g. an
archive of digital artwork by an unknown artist.
If no one is interested in the work, it's plausible that a community 
operating with the best intentions would decide that the archive is not worth 
preserving.
From a market perspective, this is a sign of efficiency.
Storage space and bandwidth are finite, and the principle of supply and demand 
can be an efficient instrument of resource allocation.
But the future value of data is not always knowable in advance.
The same artwork might come to be valued widely, as is the case with the work of
many artists who only found posthumous success.

If the community as a whole is not capable of total preservation, 
the second approach is to form smaller organizations like the Internet Archive
that are dedicated to this cause.
Such an organization would aim to archive everything on the publicly available
peer-to-peer web.
Even the most obscure bits of data would enjoy stable hosting once that data
was archived.
And because the data is content-addressed, there wouldn't be a need to access
the data through an archive interface.
The archive would ensure the continued availability of the data simply by 
hosting a copy of the data on a stable archive node.
The Internet Archive demonstrates that this level of archiving is 
possible and doesn't require active involvement from the entire community of 
network users.
It also reveals the massive amount of funding required for an archive 
to operate at this scale.

A third, and final, approach to consider is a rewards system that incentivizes
users to preserve data that no one volunteers to preserve.
