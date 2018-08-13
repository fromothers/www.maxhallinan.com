---
layout: post
published: true
title: "Changing State Over Time Without Mutation"
tags: [ javascript, programming]
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

## I. A simplified example of the problem

It is straightforward to refresh the MTA feeds at a regular interval and
broadcast the new data to open connections.
This can be achieved by binding websocket sessions to an [event emitter](https://nodejs.org/api/events.html)
that emits data every time the feeds are refreshed.
For example, here is a websocket server that listens to a timer and sends a
message when the timer ticks.

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

But a message describing each tick is not enough.
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

This works.
Nonetheless, I want to avoid the headaches associated with mutable state.
A pure transformation from ticks to tick count seems like it should be as simple
as summing an array of numbers.

{% highlight javascript %}
const increment = (n) => n + 1;

const ns = [ 1, 1, 1, ];

const count = ns.reduce(increment, 0);
// ns.length works here too but doesn't demonstrate the principle
{% endhighlight %}

Can I take the same approach to summing the timer ticks?
The problem is that the series of ticks grows over time.
Whenever a tick occurs, I have to update a stateful array of ticks.
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

## II. A new kind of function

An Observable is like a Generator, a function that can produce many values.
But unlike a Generator, an Observable decides _when_ it will produce a value.
Consumers _pull_ values from Generator functions but Observables _push_ values
out to consumers.
This can occur asynchronously, over time, or synchronously, all at once.

That might sound complicated so let's look at a simple Observerable.

{% highlight javascript %}
const createObservable = () => ({
  subscribe: (observer) => {
    // ...
  },
});
{% endhighlight %}

An Observable is an interface with a `subscribe` method.
The `subscribe` method takes an `observer` argument.
An Observer enables the Observable to pushes new values out to the consumer.
The Observer interface specifies three methods: `next`, `error`, and `complete`.

{% highlight javascript %}
const observer = {
  complete: () => {
    console.log(`complete`);
  },
  error: (err) => {
    console.log(`error: ${err}`);
  },
  next: (x) => {
    console.log(x);
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

## III. Transforming a series of values ordered in time

Observables do not necessarily execute asynchronously.
The above example runs to completion synchronously.
But Observables are often used to model a series of values ordered in time.
The abstraction makes it possible to operate on a sequence over time in the same
way one would operate on a static sequence, like an array.

To demonstrate this, let's return to our timer.

{% highlight javascript %}
const Rx = require(`rxjs`);

const ticks = Rx.timer(0, 1000);

ticks.subscribe({
  next: () => {
    console.log(1);
  },
});
// 1
// 1
// 1
// ...
{% endhighlight %}

We've replaced `setInterval` with an Observable that pushes a new tick every
second and start this timer by calling `subscribe`.
Now we want to count the number of ticks.
To do this, we use an Observable operator called `scan`.

{% highlight javascript %}
const Rx = require(`rxjs`);
const { scan } = require(`rxjs/operators`);

const ticks = Rx.timer(0, 1000);

const ticksCount = ticks.pipe(
  scan((count, n) => count + 1, 0)
);

ticksCount.subscribe({
  next: (x) => {
    console.log(x);
  },
});
// 1
// 2
// 3
// ...
{% endhighlight %}

An Observable operator transforms the stream of observed values.
The `scan` operator is like `Array.prototype.reduce`.
`scan` folds a collection of values into a single value.
For each new tick in the `ticks` stream, `scan` is re-run and the tick count is
recomputed.
The result can be observed on the new Observable returned by `pipe`.

This is one way to track state over time without mutation.
Instead of updating a counter variable, each session reduces the `ticks`
Observable to its own stream of tick counts.
Then the websocket sends a new message every time there is a new tick count.

{% highlight javascript %}
const Rx = require(`rxjs`);
const { scan } = require(`rxjs/operators`);
const WebSocket = require(`ws`);

const ticks = Rx.timer(0, 1000);

const server = new WebSocket.Server({ port: 80, });

const add = n1 => n2 => n1 + n2;

const startSession = (ticks) => (websocket) => {
  emitter.on(`data`, (data) => {
    const ticksCount = ticks.pipe(scan(add(1), 0));

    ticksCount.subscribe({
      next: (count) => {
        websocket.send(count);
      },
    });
  });
};

server.on(`connect`, startSession(ticks));
{% endhighlight %}

<!--<h2 id="sharing-the-work">Sharing the work</h2>-->
## IV. Sharing the work

There is one detail that hasn't been accounted for.
We know that the timer does not start ticking until `subscribe` is called.
Calling `subscribe` begins the execution of an Observable.
But we pass the same `ticks` Observable to each new websocket connection.
`ticks.subscribe` is called by every connection.
What happens when `subscribe` is called more than once on the same Observable?

The answer depends on the Observable implementation.
An Observable can be "unicast" or "multicast".
A unicast Observable does not broadcast the same stream to more than one
Observer.
Every `subscribe` call starts a fresh execution of the Observable.
For this reason, the example below will log `'bar 1'` _after_ logging `'foo 1'`
and `'foo 2'`.

{% highlight javascript %}
const Rx = require(`rxjs`);
const { scan } = require(`rxjs/operators`);

const add = n1 => n2 => n1 + n2;

const ticks = Rx.timer(0, 1000).scan(add(1), 0);

ticks.subscribe({
  next: (x) => {
    console.log(`foo ${x}`);
  }
});

setTimeout(() => {
  ticks.subscribe({
    next: (x) => {
      console.log(`bar ${x}`);
    }
  });
}, 1000);
{% endhighlight %}

Our `ticks` Observable is unicast because RxJs Observables are unicast by
default.
Thus, each websocket connection starts its own timer by calling
`ticks.subscribe`.
The ticks counted by one session are not the same ticks counted by another
session.

Depending on the number of concurrent connections, it might be okay for each
session to start its own timer.
But I don't want each session to poll the MTA feeds independently.
That would consume more bandwidth than necessary and, given enough concurrent
connections, might amount to a DDoS attack on the MTA.

Fortunately, it is possible to create a multicast Observable.
Multicast Observables share a single stream of values with all Observers.
Observers receive only the values produced after they have subscribed.
Unicast and multicast Observables have different use cases.<sup><a id="ref-1" href="#cite-1">1</a></sup>
Here, a multicast Observable enables us to produce new data once for all 
consumers of that data.

{% highlight javascript %}
const Rx = require(`rxjs`);
const { multicast, scan } = require(`rxjs/operators`);
const WebSocket = require(`ws`);

const ticks = Rx.timer(0, 1000).pipe(multicast(new Rx.Subject()));

const server = new WebSocket.Server({ port: 80, });

const add = n1 => n2 => n1 + n2;

const startSession = (ticks) => (websocket) => {
  emitter.on(`data`, (data) => {
    const ticksCount = ticks.pipe(scan(add(1), 0));

    ticksCount.subscribe({
      next: (count) => {
        websocket.send(count);
      },
    });
  });
};

server.on(`connect`, startSession(ticks));
{% endhighlight %}

All that is left for me to do is replace `timer` with a stream of MTA feed 
updates and replace `add` with a function that reduces the stream to a history 
of train locations.

## V. Practically speaking

Observables are a central component of functional reactive programming (FRP).
The vocabulary of FRP often sounds overwhelmingly technical.
Perhaps that technical language has hidden some useful ideas from programmers 
who have a need to use them. 
I hope I have revealed a little of that usefulness.

**Notes**

<ol>
  <li>
    <p>
      <a href="#ref-1">^</a>
      <fn id="cite-1">
        <a href="https://github.com/tc39/proposal-observable/issues/66">
          tc39/proposal-observable: "Discussion: Multicast vs. Unicast"
        </a>
      </fn>
    </p>
  </li>
</ol>
