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

But a message describing each next tick is not enough.
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

I want to avoid the headaches that come with mutable state.
I can clearly see how to sum a series of values without mutating a counter
variable.

{% highlight javascript %}
const increment = (n) => n + 1;

const ns = [ 1, 1, 1, ];

const count = ns.reduce(increment, 0);
// ns.length works here too but doesn't demonstrate the principle
{% endhighlight %}

I would like to take the same approach to summing the timer ticks.
The problem is that the series of ticks grows over time.
Each time a tick occurs, I have to update a stateful array of ticks.
This only exchanges one piece of mutable state for another.

{% highlight javascript %}
const increment = (n) => n + 1;

const startSession = (emmiter) => (websocket) => {
  const ticks = [];

  emitter.on(`data`, (tick) => {
    ticks.push(tick);

    const tickCount = ticks.reduce(increment, 0);

    websocket.send(tickCount);
  });
};
{% endhighlight %}

The intuition to treat the ticks as a collection like an array is good.
The intuition to sum that collection with pure functions is also good.
Now I need an abstraction for a series of values occurring over time.
I want to transform the time-based series as I would transform an array, without 
having to manually re-run the transformation and store state each time a new 
value is produced.
For this I can use an Observable.

An Observable is like a Generator, a function that can produce many values.
But unlike a Generator, an Observable decides _when_ it will produce a value.
Consumers _pull_ values from Generator functions but Observables _push_ values 
out to consumers.
This can occur asynchronously, over time, or synchronously, all at once.

That might sound complicated so let's look at a simple Observer.

An Observable is an interface with a `subscribe` method.

{% highlight javascript %}
const createObservable = () => ({
  subscribe: (observer) => {
    // ...
  },
});
{% endhighlight %}

The `subscribe` method takes an `observer` argument.
An Observer enables the Observable to pushes new values out to the consumer.
The Observer interface specifies three methods: `next`, `error`, and `complete`.

{% highlight javascript %}
const observer = {
  complete: () => {
    console.log(`complete`);
  },
  error: () => {
    console.log(`error`)
  },
  next: (x) => {
    console.log(x)
  },
};
{% endhighlight %}

`next` is called when the Observable produces a new value.
`error` is called if the Observable reaches an error state.
And `complete` is called if there are no more values to produce.

{% highlight javascript %}
const createObservable = () => ({
  subscribe: (observer) => {
    observer.next(`foo`);
    observer.next(`bar`);
    observer.next(`baz`);
    observer.complete();
  },
});
{% endhighlight %}

The Observable does not start producing values until the `subscribe` method is 
called.

{% highlight javascript %}
const observable = createObservable();
observable.subscribe(observer);
// 'foo'
// 'bar'
// 'baz'
// 'complete'
{% endhighlight %}

The Observable is our "array of values occurring over time".
One of the powerful features of Observables is that they model 
sequentially occurring values 
