---
layout: post
title: "The Silo of Obscurity"
subtitle: "A dilemma of availability on peer-to-peer networks"
---

Many peer-to-peer networks address a resource by _what_ it is and not _where_ 
it is.
This is called content addressing.
On a content-addressed, peer-to-peer network, a resource is not tied to a
single host.
Any node that downloads the resource is capable of hosting it.
Multiple nodes can host the same data simultaneously.
If one host goes offline, the resource is still accessible from other hosts.
The resource is available until all hosts go offline and the likelihood of this
happening decreases as the number of hosts grow.
Meanwhile, the address of the resource remains the same.
Links to the resource do not break when the location of the resource changes.

For these reasons among others, peer-to-peer networks have recently been 
celebrated as a solution to "information silos", a situation on client-server 
networks where data is stored in a closed system and access to the data is 
controlled.
Personal data accessed over social networks like Facebook or Instagram is a 
common example.
Location of the data on a central host enables this control.
Without an exclusive location for data on a peer-to-peer network, access to and
replication of the data becomes harder to control.
The intent is to embed the ideal of openness in the network architecture by 
making it much harder (perhaps impossible) to create a closed system of siloed
data.

But better availability on peer-to-peer networks does not mean guaranteed 
availability.
Given a valid address, a client can wait eternally for a host to connect to the 
network.
In my experience with Bittorrent, this is not uncommon.
I rarely pirate movies because the movies available to donwload are often not 
the movies I want to watch.
A torrent for a Canadian documentary is useless if I can only locate peers 
seeding the latest Hollywood blockbuster.
What I actually watch is often a compromise between my tastes and what is 
available to download.
That is because resources in greater demand are more likely to have multiple 
hosts.
As the number of hosts grows in some rough proportion to the demand, the 
popular resources generally enjoy greater availability than unpopular resources.

My primary concern is that this effect could distort a peer-to-peer web through 
a process that resembles natural selection: available resources will be those 
that have proved their fitness, either organically through propagation to a 
large number of peers or artificially, by location on a small number of 
resilient hosts, e.g. a VPS.
This dynamic is inconsistent with the ideal of openness that a peer-to-peer 
network is intended to manifest.
When human subjectivity, expressed both as a desire to download data and a 
willingness to host data, influences the availability of the data, then the 
network is vulnerable to the bias of its users. 
Like the virulent echo chambers that have emerged on social networks, a web 
based on such a network might become more a tool for confirming bias than 
for deepening understanding.

Karisa McElvy, a founder of the Dat peer-to-peer network, writes that the 
Dat community must cooperate to stabilize low-availability resources:

> Decentralization of data produces challenges though — just like a torrent, 
> data that is decentralized can go offline if there aren’t any stable and 
> trusted peers... To mitigate it, we invoke the human part of a commons — the 
> data will be commonly managed... When a dat becomes less healthy, the 
> community can be alerted and make sure the resource does not go down. 
> Decentralized tech and decentralized humans working together to use commons 
> methodology in practice.
>
> ["The Web of Commons"](https://blog.datproject.org/2017/09/21/dat-commons/)

Even though the Dat network is public and has been used to host many kinds of data,
the initial use case of the Dat project was large scientific datasets.
I think the approach to low availability that Karisa describes is a reasonable
approach to scientific data, where
a common understanding and belief in the value of the data is more likely.
But I'm less confident that the public can be relied on to voluntarily save 
a Dat archive of something banal like a web gallery of drawings I built in
middle school.

One could say that a lack of demand on the network for this data indicates
that it's not worth saving.
I agree that the principles of supply and demand can be used to efficiently 
allocate resources and that there's some need for prioritization while storage 
space is finite.
The problem is that the future value of data is not always knowable in advance.
This is part of the implied perspective of the Internet Archive: save everything
on the web because you'll never know what you'll need later.
I too feel that destroying or losing information should be avoided, even when 
the present demand for that information is low.
