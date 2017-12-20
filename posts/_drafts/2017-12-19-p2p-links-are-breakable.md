---
layout: post
title: "The Silo of Stardom: An Availability Dilemma on p2p Networks"
---

Because I live in Germany, I am often out of sync with world wide web traffic
emanating from America.
The heaviest web traffic starts as I'm winding down for the day and ends 
sometime shortly before I wake up.
That's not true of everything; some web-based conversations span multiple days,
are reactions to current events that occur at odd times relative to American
timezones, or are populated by people who don't live in America.
Nonetheless, things tend to take shape on the American web as my day is ending
and conclude shortly before I wake up.
Simply put: I can tell when America is sleeping.

The [Peer-to-Peer Web/ Los Angeles](https://peer-to-peer-web.com/los-angeles)
event was one of those things.
I was unable to watch the livestream because it started at 22:00 local time
on a Sunday night.
Later that week, I received an email from the organizers with a link to an
archive of the livestream.
I received this email at 2:00 local time and followed a link to the archives
sometime around 7:00.
Citing the expense of hosting and bandwidth, the Peer-to-Peer Web / Los Angeles
organizer opted to host the videos on the dat network.
I opened the dat url in Beaker browser (a web browser that is also a dat 
client).
So I started to stream the first video from 1 peer but the stream was broken 
sometime shortly after. 
The peer had disappeared.
It's possible that this was someone in Los Angeles who had just powered down
their computer and gone to bed.
I kept Beaker open at work, checking in from time to time.
Sometime in the middle of the afternoon, maybe around 15:00, a couple of peers
appeared.
This is also the same time window during which I generally start to sense (100%
unscientifically) that Americans are waking and logging on to the internet.
The availability of the livestream archive seemed to follow the pattern of 
American web traffic.
By the end of the day, I had 9 peers and downloaded the archive without
interruption.

Broken links are a common problem on HTTP networks.
Links break for many reasons: the owner of the resource can't afford the
cost of hosting; an old address does not redirect to a new address; a public
resource is made private.
In each case, a link to a resource is found to be broken if the resource is no
longer located at its web address.
The link stays broken even if the resource itself is duplicated at a different
location on the network.
A human might understand these two resources to be equivalent in their content
or meaning, but the network does not.
That is because an HTTP network ties resources to network locations.
Every web address is first the address of the computer where that resource is
stored.
If that computer cannot provide the resource, the resource ceases to exist.

On peer-to-peer networks like dat, a resource is identified by
_what is is_ (content-addressed) instead of _where it is_ (location-addressed).
When a resource is content-addressed, it is independent from its location.
A single resource could be hosted in multiple locations at once.
The network understands that copies of the resource, though physically
different, are logically the same.
This means that any host can go offline without effecting the resource's
availability.
Except if all hosts go offline.
Then a link to the resource is broken, at least for the time being.

Popular resources are more likely to be available on a peer-to-peer network.
As more peers download and seed the resource, the probability rises that the
resource will be available at any given time.
But this does not mean that link rot is not a real problem.
In my experience, it's not even an uncommon problem.
I rarely pirate movies because I often find that the movies available to
download are not the movies I want to watch.
What I end up watching is often a compromise between my tastes and what was 
available to download.
As a media pirate, I have nothing to say about torrents that are perpetually
lacking seeders.
When I got to the store to steal a wrench, I don't complain when the wrenches
are out of stock.
But I'm also someone who is interested in the possiblity that peer-to-peer
networks are a remedy to some (perhaps many) of the imperfections of http
networks.
As that person, I think it's worth considering the plight of the unpopular
resource on a world wide web backed by a peer-to-peer network.

My primary concern is that such a network could be distorted through a process
that resembles natural selection: available resources will be those that have
proved their fitness, either organically through propagation to a large number
of peers or artificially, by location on a small number of resilient hosts,
e.g. a VPS.
While the HTTP web suffers from silos of information, where the data is trapped
in a proprietary system, a peer-to-peer web could suffer from "silos of
stardom", where data that is not popular enough effectively doesn't exist.
I think of this as a distortion because it is not an intended effect of the
network architecture if that intention is to promote availability and openness.












































as the effect of
a kind of natural selection. 

It seems to me that
In the whole world, there might only be three people interested in a song about
alligators.
And unless at least one of these three people is perpetually online, the resource
will not be available when a fourth person comes along.
So then one of the group, wanting to promote this song more widely, starts
hosting it on a VPS that's always connected to the network.
Now other people can host this alligator song too.
The one host doesn't exist in exclusion of other hosts, as it does on an http
network.
But there's a different problem here: in order for a resource to persist on the
network it either needs to be popular or it needs the protection of an advocate
willing to ensure that the resource is reliably hosted.
The effect is a kind of natural selection: available resources will be those
that have proved their fitness, either organically through propagation to a
large number of peers or artificially, through a single (or small number) of
resilient hosts.

If the http network is replaced with a peer-to-peer network as the basis for 
the world wide web, it 
If a peer-to-peer network is used as a new transport layer for the mainstream 
web, 

I think it is worth thinking about the potential regular unavailability of 
unpopular resources on peer-to-peer networks.


In this sense, peer-to-peer networks are less vulnerable to link rot than
networks like HTTP where a resource is tied to a single origin.
If a server goes down on a peer-to-peer network,
But what happens to resources that are not popular yet or never will be?
When I first started using bittorrent to pirate videos, shortly after the
network was started, I found that often the videos I watched weren't as much
the videos I wanted to watch as they were the videos that were available.
There was an address for a video I was interested in but no one was seeding that
address.
The most reliable videos were recent Hollywood blockbusters or videos with a
significant cult following, e.g. _Monthy Python and the Holy Grail_.
I lost interest in the Bittorrent network because I could never find the content
I was really looking for.
I found myself being funneled into what was available rather than what I desired.
Some years later, around 2012, I gave Bittorrent a second try.
While there was definitely more content, I found that the same pattern emerged.
I would think of a movie I wanted to watch, find a torrent address for it, and
then find that no one was seeding.
So I'd be forced to think of a different movie and maybe a third, until I found
one I was actually able to download.
The movies I watched then were always a compromise with the network and that
compromise rarely yielded my first choice.
I accepted this as the constraint of getting something for free illegally.
It seemed absurd to complain about it in the same way that it would be absurd
for a thief to complain that the store does not have the inventory he wishes
to steal.
But if the future of the web is a peer-to-peer network, this problem of low
availability for less popular content (common in my experience) suddenly seems
very important.

Broken links, "the 404 problem", are one of the major concerns that drive
development of the dat network and, more broadly, the peer-to-peer web movement.

I am interested in the possibility that peer-to-peer networks are a remedy to
some (perhaps many) of the imperfectons of http networks.
With that background, I found this experience extra interesting.
As I thought about what had happened, it started to seem that availability on
a peer-to-peer network is more vulnerable to break than I had first considered.
And that peer-to-peer networks are vulnerable to certain distortions
which are not found on an http network, exactly because of the difference in
a resource's availability.

The more I think about this, the more of a problem it seems to me.

Broken links, "the 404 problem", are one of the major concerns that drive
development of the dat network and, more broadly, the peer-to-peer web movement.
And they're not wrong.
But not everything on the network will be popular enough to benefit from this
inverse scaling.
Some content is uninteresting to most people.
In the whole world, there might only be three people interested in a song about
alligators.
And unless at least one of these three people is perpetually online, the resource
will not be available when a fourth person comes along.
So then one of the group, wanting to promote this song more widely, starts
hosting it on a VPS that's always connected to the network.
Now other people can host this alligator song too.
The one host doesn't exist in exclusion of other hosts, as it does on an http
network.
But there's a different problem here: in order for a resource to persist on the
network it either needs to be popular or it needs the protection of an advocate
willing to ensure that the resource is reliably hosted.
The effect is a kind of natural selection: available resources will be those
that have proved their fitness, either organically through propagation to a
large number of peers or artificially, through a single (or small number) of
resilient hosts.
In either case, what is available on the network will always be less than the
total number of addresses in use.

what could have been available on the network.
The world wide web has demonstrated that people are interested in self-hosting
but that self-hosted things are not reliable.

But the person who puts something onto the network,

Especially in the early days of Bittorrent, it is important to remember that the
movies I downloaded from the network weren't always the movies I wanted to watch
the most.
I would find a network address for a movie I wanted to watch but no one would be
seeding the movie.
So the file would hang out in my queue for days, weeks, and months while I waited
for someone with that file to connect to the network.
The movies I watched were not always the movies I most wanted to watch.
They were the movies I wanted to watch of those that were available on the
network.
And those that were most likely to be available on the network, are those that
other people wanted to watch - the most popular content is the most available.
And if the available content directs the consumption habits of the network, then
peer-to-peer networks are vulernable to a narrowing of content, perhaps even
more so than http networks?

What if people were incentivized to seed unpopular content?

by its content
instead of its location.
Advocates for the decentralized web note that peer-to-peer networks help to
mitigate the problem of broken links.

* [The Web of Commons](https://blog.datproject.org/2017/09/21/dat-commons/)

> If products fail or are deemed not economically viable (for example Vine,
> Google Reader, etc), the whole suffers.

> The rationale given for companies to create paywalls is that it is expensive
> to collect, store, organize, present, and provide bandwidth for the billions
> of pages of articles and datasets.

It is still expensive to host data, whether the hosting is done by individuals
or corporations.

> Decentralization is a clear way we can reduce the costs of this hosting and
> bandwidth — as more people come to download the articles and data from the
> journal or library or university, the faster it gets. The dream is that
> universities could turn their currently siloed servers into a common resource
> that is shared amongst many universities. This would cut costs for everyone,
> improve download speed, and reduce the likelihood that data is lost.

Does this actually decentralize?
It scales in a way that is similar to bitcoin miners.
Structurally it's decentralized but there's a nontrivial possibility that socially,
these decentralized data silos become socially centralized.

> Decentralization of data produces challenges though — just like a torrent,
> data that is decentralized can go offline if there aren’t any stable and
> trusted peers. In the case of scientific data, this is an immense failure.
> To mitigate it, we invoke the human part of a commons — the data will be
> commonly managed.

> To mitigate it, we invoke the human part of a commons — the data will be
> commonly managed. For example, we can detect how many copies are available in
> different places, just like a BitTorrent, and compute health for a dat — for
> example, a dat hosted at the Internet Archive, University of Pennsylvania,
> and UC Berkeley is probably very healthy and has low probability of ever
> going offline, while a dat hosted by 5 laptops might go down tomorrow — even
> though there are more peers. When a dat becomes less healthy, the community
> can be alerted and make sure the resource does not go down. Decentralized
> tech and decentralized humans working together to use commons methodology in
> practice.
