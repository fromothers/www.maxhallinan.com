---
layout: post
title: "p2p Links are Breakable"
---

Because I live in Germany, I am often out of sync with world wide web traffic 
emanating from America.
The heaviest web traffic starts as I'm winding down for the day and ends sometime
shortly before I wake up.
That's not true of everything; some web-based conversations span multiple days,
are reactions to current events that occur at odd times relative to American
timezones, or are populated by a non-American majority.
Nonetheless, the pattern of things taking shape on the American web as my day
is ending and these things concluding shortly before I wake up is more common 
than I expected to find when I moved to Germany.
Simply put: I can tell when America is sleeping.

The [Peer-to-Peer Web/ Los Angeles](https://peer-to-peer-web.com/los-angeles) 
event was one of those things.
I was unable to watch the livestream because it started at 22:00 on a Sunday 
night.
Later that week, I received an email from the organizers with a link to an 
archive of the livestream.
I received this email at 2:00 local time and followed a link to the archives
sometime around 7:00.
Citing the expense of hosting and bandwidth, the Peer-to-Peer Web / Los Angeles
organizer opted to host the videos on the dat network.
I opened the dat url in the Beaker browser and found 1 other peer. 
So I started to stream the first video but the stream was broken sometime 
shortly after starting.
The peer had disappeared.
It's possible that this was someone in Los Angeles who had just powered down
their computer and gone to bed.
I kept Beaker open at work, checking in from time to time.
Sometime in the middle of the afternoon, maybe around 14:00 or 15:00, a couple 
of peers appeared.
This is also the same time window during which I generally start to sense that
Americans are waking and logging on to the internet.
The availability of the livestream archive was following the pattern of American
web traffic.
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
_what is is_ (content addressed) instead of _where it is_ (location addressed).
When a resource is content-addressed, it is independent from its location.
A single resource could be hosted in multiple locations at once.
The network understands that copies of the resource, though physically 
different, are logically the same.
This means that any host can go offline without effecting the resource's 
availability.
Except if all hosts go offline.
Then a link to the resource is broken, at least for the time being.

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


I am interested in the possibility that peer-to-peer networks are a remedy to 
some (perhaps many) of the imperfectons of http networks.
With that background, I found this experience extra interesting.
As I thought about what had happened, it started to seem that availability on 
a peer-to-peer network is more vulnerable to break than I had first considered.
And that users of a peer-to-peer networks are vulnerable to certain distortions
which are not found on an http network, exactly because of the difference in 
a resource's availability.

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

- [The Web of Commons](https://blog.datproject.org/2017/09/21/dat-commons/)

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
