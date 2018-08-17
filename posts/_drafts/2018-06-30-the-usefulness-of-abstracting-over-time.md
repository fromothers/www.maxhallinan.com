---
layout: post
published: true
title: "The Usefulness of Abstracting Over Time"
tags: [explorable, programming]
---

I recently [wrote](/posts/2018/06/02/changing-state-over-time-without-mutation/)
about building a websocket server.
It tracks the location of trains in the New York City subway.
Location data is sourced from the MTA [data feeds](http://datamine.mta.info/).
The feeds are polled every 30 seconds.

My last post failed to acknowledge a design flaw.
The server _always_ asks for new location data, every 30 seconds, even when no
one is listening.
So bandwidth is wasted and unnecessary load is placed on a free service.
Better to ask for new data only when the data is in demand.

Polling on demand gets messy fast.
My first attempt made liberal use of mutable state.
And mutable state is exactly what I want to avoid.
In the last post, I replaced mutable state with Observables.
Here is a second occasion when the Observable pattern freed me from the mutable
state trap.

## I. Clarity through naivety

We'll use a timer in place of polling the MTA feeds.
This keeps the discussion uncluttered by details specific to the MTA.
Whether timer ticks or a train locations, we're not concerned with the data
itself.
Our concern is how the data flows through the application.

We begin with a timer that ticks every second.
Our task is to pause the timer when there are no websocket connections and start
the timer when a client connects.
But we're not jumping into the Observable implementation yet.

The key to understanding a pattern is often understanding a problem that the
pattern solves.
The problem here is sharing information across isolated contexts without
mutating global state.
To understand what that means, let's first consider my initial approach &mdash;
the approach that uses the mutable state we want to avoid.

The pausable behavior has two parts: knowing _how_ to pause the timer and
knowing _when_ to pause it.
Let's start with knowing when to pause it.
We should stop the timer when there are no websocket connections.

To know the number of current connections, we must count opened connections and
closed connections.
These are the first pieces of global mutable state: counters that are
incremented by the connection and close event handlers.

{% highlight javascript %}
let sessionStarts = 0;
let sessionEnds = 0;

server.on(`connection`, (socket) => {
  sessionStarts = sessionStarts + 1;

  socket.on(`close`, () => {
    sessionEnds = sessionEnds + 1;
  });
});
{% endhighlight %}

If we know the number of opened and closed connections, we can work out the
number of current connections with a little math:

```
current connections = opened connections - closed connections
```

Having determined the number of current connections, we know when to start and
stop the timer.

The timer should start when the number of current connections is 1.

{% highlight javascript %}
server.on(`connection`, (socket) => {
  sessionStarts = sessionStarts + 1;

  if (sessionStarts - sessionEnds === 1) {
    // start the timer
  }

  // ...
});
{% endhighlight %}

And the timer should stop when the number of current connections is less than 1.

{% highlight javascript %}
server.on(`connection`, (socket) => {
  // ...

  socket.on(`close`, () => {
    sessionEnds = sessionEnds + 1;

    if (sessionStarts - sessionEnds > 1) {
      // stop the timer
    }
  });
});
{% endhighlight %}

Now that we know when to pause the timer, we need a timer that can be paused.

### An aside about pausable computations

Is it possible to pause an Observable?
To answer that question, we must think about what an Observable is.
[Recall](/posts/2018/06/02/changing-state-over-time-without-mutation/#ii-a-new-kind-of-function)
that Observables, like Generators, are both functions that produce one or more
values.

A Generator is easily paused.
In fact, execution of a Generator is suspended each time a value is produced.
Execution resumes only when the caller asks for the next value.

An Observable behaves differently.
While consumers _pull_ values from Generators, Observables _push_ values out to
consumers.
This means that the consumer does not determine when the value is produced.
Thus the consumer cannot suspend execution of the Observable.

This is only problematic if we require the pausable timer to maintain a
continuous execution context.
Continuous context is required when a paused computation should resume from its
last state.

For example, a pausable function that counts infinitely up from one must
preserve its execution context.

```
1 2 3 pause 4 5 6 pause 7 8 9 pause 10 11 12
```

If the context is not preserved, then pausing the function will reset the count.

```
1 2 3 pause 1 2 3 pause 1 2 3 pause 1 2 3
```

But our timer (and polling) is stateless.
No context preservation is required to produce a tick every second.
This means that we don't need a truly pausable timer.
Instead, we can create a new timer when we need one and dispose of it when we
don't.

### A "pausable" timer

First, we define a function that creates an instance of the timer Observable.
The [`multicast`](/posts/2018/06/02/changing-state-over-time-without-mutation/#iv-sharing-the-work)
operator enables us to share one timer with multiple consumers.

{% highlight javascript %}
const Rx = require(`rx`);
const { multicast, } = require(`rx/operators`);

const createTicks = () =>
  Rx.timer(0, 10000).pipe(multicast(new Rx.Subject()));
{% endhighlight %}

Whenever the timer should start ticking, a new timer Observable is created.
Execution of the Observable is triggered by calling `connect`.
The Subscription returned by `connect` is saved so we can stop the timer later.

{% highlight javascript %}
let ticks = null;
let subscription = null;

server.on(`connection`, (socket) => {
  sessionStarts = sessionStarts + 1;

  if (sessionStarts - sessionEnds === 1) {
    ticks = createTicks();
    subscription = ticks.connect();
  }

  // ...
});
{% endhighlight %}

Now the connection handler is free to consume the stream of ticks.

{% highlight javascript %}
let ticks = null;
let subscription = null;

server.on(`connection`, (socket) => {
  sessionStarts = sessionStarts + 1;

  if (sessionStarts - sessionEnds === 1) {
    ticks = createTicks();
    subscription = ticks.connect();
  }

  ticks.subscribe({
    next: (tick) => {
      socket.push(tick);
    }
  });

  // ...
});
{% endhighlight %}

To "pause" the timer, we destroy the timer Observable.
The Observable is destroyed by calling `Subscription#unsubscribe`.
Unless `unsubscribe` is called, the timer will continue to run in the
background.

{% highlight javascript %}
server.on(`connection`, (socket) => {
  // ...

  socket.on(`close`, () => {
    sessionEnds = sessionEnds + 1;

    if (sessionStarts - sessionEnds  1) {
      subscription.unsubscribe();
    }
  });
});
{% endhighlight %}

Finally, we reset all related state.

{% highlight javascript %}
server.on(`connection`, (socket) => {
  // ...

  socket.on(`close`, () => {
    sessionEnds = sessionEnds + 1;

    if (sessionStarts - sessionEnds  1) {
      subscription.unsubscribe();
      ticks = null;
      subscription = null;
    }
  });
});
{% endhighlight %}

So concludes the mutable state approach to pausing a timer.
This approach is essentially about the concept of "doing".
The timer's behavior is an effect of doing things like incrementing counters,
creating timers, and cleaning up state.
To achieve the same behavior without mutable state, we must shift our focus from
doing to being.

## II. Be instead of do

<blockquote>
  <p>
    For me, functional programming is not about doing. It's about being.
  </p>
  <cite>
    &mdash; Conal Elliot, <a href="https://www.youtube.com/watch?v=j3Q32brCUAI&feature=youtu.be&t=4m21s"><em>The Essence and Origins of Functional Reactive Programming</em></a>
  </cite>
</blockquote>

If doing means instructing the computer, then being means describing the result.
A description of the result is a definition of a thing.
Being means expressing program behavior by defining things.

What are things in programming?
Values are things.
Functional programming uses functions to define things.
A function `Foo -> Bar` is one way to define `Bar`.
Ultimately, the output of a program is defined as a function of the input.

We have defined some things, values like `sessionStarts` and `sessionEnds`.
But those definitions have not made our code less about doing.
That is because many things are imperfectly defined.

Our definitions ignore an essential connection between value and time.
For example, we defined `sessionStarts` as a number.
Then that number is incremented for each connection event.
So this is not just a number.
This is a number that varies over time.

All of the doing in our program is an attempt to confront time-varying value.
And all of the timer's behavior flows from that variance.
To exchange doing for being, we must seek an abstraction of value over time.

Functional reactive programming (FRP) is an approach to working with
time-varying values.
FRP was first formulated by Conal Elliot and Paul Hudak in a paper that
proposed two abstractions: Behavior and Event.
Behavior and Event both model time-varying values.
The difference between a Behavior and an Event is a distinction of _when_ the
value exists.

A Behavior exists always and an Event exists sometimes.
The classic example of this distinction is mouse position and mouse clicks.
There is always a current value of the mouse position but there is only a last
occurrence of the mouse click.

When the presence of value is unbroken over time, then the value is said to be
continuous.
Values that are not continuous over time are said to be discrete.
Behaviors are continuous and Events are discrete.

We have the opportunity to use both Behaviors and Events.
A connection event is discrete.
The number of current connections is continuous.
The former has only a last occurrence.
The latter has a current value.
The most precise definition of these things would treat them as different types.

Instead, we will use one abstraction to represent both.
An Observable is a stream of discrete values over time, practically equivalent
to an Event.
Conflating continuous and discrete values is imprecise.
Nonetheless, we can model everything as an Observable and still manage to derive
the desired behavior.
With apologies to Elliot and Hudak, let's continue.

## III. Make time concrete

<blockquote>
  <p>
    &hellip; events may be combined with others, to an arbitrary degree of
    complexity, thus factoring complex animation logic into semantically rich,
    modular building blocks.
  </p>
  <cite>
    &mdash; Conal Elliot and Paul Hudak,
    <a href="http://conal.net/papers/icfp97/">
      <em>Functional Reactive Animation</em>
    </a>
  </cite>
</blockquote>

Our goal is to replace instructions with definitions.
The definitions will be expressed as functions, one value being defined as the
function of another value.
The pausable timer is a function of two time-varying values: connection counts
and connection ends.
To define the timer, we must first define those values.

There is no ready-made Observable that counts opened and closed websocket
connections.
Those numbers are themselves functions of the connection and close events.
RxJs provides a [`fromEvent`](https://rxjs-dev.firebaseapp.com/api/index/fromEvent)
constructor that creates an event stream.
We can use `fromEvent` to create a stream of connection events emitted by the
server.

{% highlight javascript %}
const connection$ = Rx.fromEvent(server, 'connection');.
{% endhighlight %}

Then the connections can be counted by summing that stream.

{% highlight javascript %}
const add = (n1) => (n2) => n1 + n2;

const addOne = add(1);

const connectionCount$ = connection$.pipe(scan(addOne, 0));
{% endhighlight %}

Counting closed connections is a little more complicated.
The close event is emitted by the _socket_, not the server.
In our first iteration, the socket is exposed through the connection event as
the first argument to the event handler.
But now the `connection$` Observable is handling the event.
How can we access arguments to the event handler without an event handler?

Fortunately, the Observable passes those values along to us.
The stream of connection events is really a stream of arguments to the event
handler.
For each connection event, an arguments array is pushed into the event stream.
So the socket for each connection is the first item of each array in the stream.
We can use [`map`](https://rxjs-dev.firebaseapp.com/api/operators/map) to
transform that stream of arrays into a stream of sockets.

{% highlight javascript %}
const head = xs => xs[0];

const socket$ = connection$.pipe(map(head));
{% endhighlight %}

Now we might be tempted to map the sockets stream to a stream of close events.

{% highlight javascript %}
const close$ = socket$.pipe(
  map((socket) => Rx.fromEvent(socket, 'close')),
);
{% endhighlight %}

But the result is a stream of streams, one stream for each socket.
And we want a flat stream of close events.
So we should use [`flatMap`](https://rxjs-dev.firebaseapp.com/api/operators/flatMap)
instead.
`flatMap` merges all of the sub-streams into one stream of close events.

{% highlight javascript %}
const close$ = socket$.pipe(
  flatMap((socket) => Rx.fromEvent(socket, 'close')),
);
{% endhighlight %}

Again, we can count occurrences of the event by summing the stream.

{% highlight javascript %}
const closeCount$ = Rx.merge(
  close$.pipe(scan(increment, 0)),
);
{% endhighlight %}

This definition exhibits some unexpected behavior.
If we observe `closeCount$`, we might notice that the first value in the stream
is eventually `1`.
There is no value `0` preceding the first close event.

Values in the `closeCount$` stream are defined as a function of values in the
`close$` stream.
When there are no values in the first stream, then there is nothing to compute.
So when `close$` is an empty stream, `closeCount$` is also an empty stream.

This is one moment where the imprecision of using an Event to model a Behavior
leads to unexpectedly complicated code.
Close events have only a last occurrence and not a current value.
Observables naturally conform to this model of time-varying value.
But the close event count _should_ have a current value and Observables have no
such concept.

The best we can do is set an initial value in the stream.
The value of the close event count should be zero when no close event has
occurred.
To set that initial value, we merge the count stream with a stream of `0`.

{% highlight javascript %}
const zero$ = Rx.of(0);

const closeCount$ = Rx.merge(
  zero$,
  close$.pipe(scan(increment, 0)),
);
{% endhighlight %}

We have finished defining our foundational time-varying values:
`connectionCount$` and `closeCount$`.
Now we can start to define the timer as a function of those values.

The timer should pause when the number of current connections is less than 1.
That number is a function of the difference between opened connections and
closed connections.

{% highlight javascript %}
const subtract = (x, y) => x - y;

const currentCount$ = Rx.combineLatest(
  [ connectionCount$, closeCount$, ],
  subtract
);
{% endhighlight %}

Then the paused condition is defined as a function of `currentCount$`.
The latest value in the stream should be `true` when the timer is paused and
`false` when it is not.

{% highlight javascript %}
const isPaused = (count) => 1 > count;

const pause$ = currentCount$.pipe(map(isPaused));
{% endhighlight %}

Now that we know when to pause the timer, how do we pause it?
Recall that our first iteration did not truly pause the timer.
Instead, we created and destroyed timers whenever the paused state changed.

Conceptually, this approach is sound and we can use
[`switchMap`](https://rxjs-dev.firebaseapp.com/api/operators/switchMap) to do
the same thing.
`switchMap` changes the source of the values in a stream.
Each time the source changes, `switchMap` destroys the previous source.

When the ticking is paused, we switch from the timer to an Observable that never
produces a value.
When the ticking is resumed, we switch to a new timer instance.
And we're no longer burdened by managing the timer Subscription.
`switchMap` destroys the timer each time we switch to the paused state.

{% highlight javascript %}
const tick$ = pause$.pipe(
  switchMap(isPaused => isPaused ? Rx.NEVER : Rx.timer(0, 1000)),
  multicast(new Subject()),
);
{% endhighlight %}

Finally, we trigger the Observable's execution by calling `connect`.
Our first timer started ticking immediately.
This timer won't start ticking until a client connects to the server.

{% highlight javascript %}
ticks$.connect();

server.on(`connection`, () => {
  tick$.subscribe({
    next: (tick) => {
      // ...
    }
  });
});
{% endhighlight %}

All the instructions have been replaced with definitions.
We are freed from the mutable state trap.

## IV. Say what you mean

We defined a timer that ticks only when a client is connected to the server.
The timer is defined as a function of websocket connections, an arrow from
connections to ticks.

<div
  class="hide-below-medium"
  id="observables-explorable-1">
</div>

<script src="https://static.maxhallinan.com/observables-explorable-1.js"></script>

<script>
  (function () {
    window.ObservablesExplorable1.run('#observables-explorable-1');
  }());
</script>

I've emphasized the removal of global mutable state.
But the usefulness of abstracting over time is more fundamental.
An adequate vocabulary is required to make precise definitions.
And precise definitions are required to build reasonable systems.
Abstracting over time supplies the vocabulary required to build a system that
interacts with time.
