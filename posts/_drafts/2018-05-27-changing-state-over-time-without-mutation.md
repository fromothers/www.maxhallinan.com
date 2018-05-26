---
layout: post
published: true
title: "Changing state over time without mutation"
tags: [javascript, programming]
---

I have been working on a websocket server that polls the New York City MTA
[real-time data feeds](http://datamine.mta.info/) every 30 seconds.
These feeds contain information about the current location of trains running on
New York City subway lines.
Every time the feeds are updated, my server sends a message to the open
websocket connections.
The message describes the paths that trains have taken since the connection was
opened.

I assumed this server would be a stateless pipeline from feed update to
websocket message, a simple composition of callbacks.
But I overlooked an important detail.
Incoming feeds only describe current train locations and outgoing messages
should describe all train locations since the connection started.
Each message is the sum of all feed updates that occur during the session.
This requires me to save and update a bit of state for each session.

It is straightforward to refresh the MTA feeds at a regular interval and
broadcast the new data to open connections.
This can be achieved by binding websocket sessions to an [event emitter](https://nodejs.org/api/events.html)
that emits a `data` event every time the MTA feeds are refreshed.
For example, here is a websocket server that listens to a timer and sends a
message every time the timer ticks.

{% highlight javascript %}
const EventEmitter = require(`events`);
const WebSocket = require(`ws`);

const emitter = new EventEmitter();

setInterval(() => {
  emitter.emit(`data`, 1);
}, 1000);

const server = new WebSocket.Server({ port: 80, });

const startSession = (emmiter) => (websocket) => {
  emitter.on(`data`, (data) => {
    websocket.send(data);
  });
};

server.on(`connect`, startSession(emitter));
{% endhighlight %}

But a message describing each new tick is not enough.
The message should describe the number of ticks that have occurred during the
session.
That is the difference between sending a train's current location and sending
a history of the train's locations.
In my first prototype, I settled for mutable session state.

{% highlight javascript %}
const startSession = (emmiter) => (websocket) => {
  let state = 0;
  emitter.on(`data`, () => {
    websocket.send(++state);
  });
};
{% endhighlight %}
