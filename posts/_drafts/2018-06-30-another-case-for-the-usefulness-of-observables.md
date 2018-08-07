---
layout: post
published: true
title: "Another Case for the Usefulness of Observables"
tags: [explorable, programming]
---

I recently [wrote](/posts/2018/06/02/changing-state-over-time-without-mutation/)
about a websocket server that tracks the current location of trains in the New
York City subway.
The server polls the MTA's real-time data feeds every 10 seconds.
My last post failed to acknowledge a design flaw.
The server is _always_ polling, every 10 seconds, even when no one is listening.
The latest data from the MTA is discarded when there are no open websocket
connections.
So bandwidth is wasted and unnecessary load is placed on a free service.
Better to poll the MTA feeds only when the data is in demand.

Polling on demand gets messy fast.
My first attempt made liberal use of mutable state.
And mutable state is exactly what I was working to avoid in the last post.
The last post describes how I avoided mutable state by modeling that state with
the Observable pattern.
Polling on demand was a second opportunity to use the Observable pattern as an
escape from the mutable state trap.

## I. Clarity through naivety

A problem that a pattern solves is a key to understanding that pattern.
The problem here is how to share information across isolated contexts without
mutating global state.
To understand that problem, let's first consider my initial approach, the
approach that uses the mutable state we want to avoid.

For the sake of simplicity, I will represent the idea of polling with a timer
that ticks every 10 seconds.
The timer is a multicast Observable subscribed by each websocket connection.
In the last
[post](/posts/2018/06/02/changing-state-over-time-without-mutation/),
the timer is always ticking in the background.
We will replace this timer with one that ticks only when there are open
connections.

The pausable behavior has two parts: a timer that can be paused and knowing when
to pause it.
Let's start with knowing when to pause the timer.
We should stop the timer when there are no current websocket connections.
To know the number of current connections, we must track the number of opened
connections and the number of closed connections.
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

    if (sessionStarts - sessionEnds  1) {
      // stop the timer
    }
  });
});
{% endhighlight %}

Now that we know when to pause the timer, we need a timer that can be paused.

### An aside about pausable computations

Is it possible to pause an Observable?
Recall that Observables and Generators are both functions that produce one or
more values.
A Generator is easily paused.
In fact, the execution of a Generator is suspended each time a value is
produced.
Execution resumes only when the caller asks for the next value.
But an Observable behaves differently.
While consumers pull values from Generators, Observables push values out to
consumers.
This means that the consumer does not determine when the value is produced.
Thus, the consumer cannot suspend execution of the Observable.

Pausing an Observable cannot mean pausing its execution.
This would be a problem if we required the pausable timer to maintain a
continuous execution context.
Continuous context is required when a paused computation needs to resume from
its last state.

For example, a pausable function that counts infinitely up from one should
preserve its execution context:

```
1 2 3 pause 4 5 6
---------------->
```

If the context is not preserved, then pausing the function will reset the count:

```
1 2 3 pause 1 2 3
---->       ---->
```

But our timer (and polling) is stateless.
No context preservation is required to produce a tick every ten seconds.
This means that we don't need a truly pausable timer.
Instead, we can create a new timer when we need one and dispose of it when we
don't.

### A "pausable" timer

We'll start by defining a function that creates an instance of the timer
Observable.

{% highlight javascript %}
const Rx = require(`rx`);
const { multicast, } = require(`rx/operators`);

const createTicks = () => Rx.timer(0, 10000).pipe(multicast(new Rx.Subject()));
{% endhighlight %}

The Observable returned by `createTicks` is made multicast so that there is only
ever one timer running on the server.
A unicast Observable would start a new timer for each websocket session.
This might be trivial for a timer but sharing the work becomes important when
the timer is replaced with polling.

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

To start the pausable timer, we create a new timer Observable and trigger its
execution by calling `connect`.
The Subscription returned by `connect` will be used to stop the timer when
there are no more open connections.

{% highlight javascript %}
server.on(`connection`, (socket) => {
  // ...

  socket.on(`close`, () => {
    sessionEnds = sessionEnds + 1;

    if (sessionStarts - sessionEnds  1) {
      subscription.unsubscribe();
      timer = null;
      subscription = null;
    }
  });
});
{% endhighlight %}

When the last connection closes, the timer is destroyed by calling
`Subscription#unsubscribe`.
If `unsubscribe` is not called, the timer will continue to run in the
background.
Then the state is reset until the next `connection` event starts a new timer.

So concludes the mutable state approach to pausing a timer.
This approach is essentially about the concept of "doing".
The timer's behavior is an effect of doing things like incrementing counters,
creating timers, and cleaning up state.
To achieve the same behavior without mutable state, we must shift our focus from
doing to being.

## II. Being instead of doing

> For me, functional programming is not about doing. It's about being.
>
> &mdash; Conal Elliot ["The Essence and Origins of Functional Reactive
> Programming"](https://www.youtube.com/watch?v=j3Q32brCUAI&feature=youtu.be&t=4m21s),
> Lambda Jam 2015

If doing means instructing the computer, then being means describing the result.
A description of the result is a definition of a thing.
Being means expressing program behavior by defining things.
What are things in programming?
Values are things.
Functional programming uses functions to define things.
A function `Foo -> Bar` is one way to define `Bar`.
Ultimately, the output of a program is defined as a function of the input.

Our program already defines some things, values like `sessionStarts` and
`sessionEnds`.
But those definitions have not made our code less about doing.
That is because `sessionStarts` and `sessionEnds` are imperfectly defined.
We have defined them as numbers but they are numbers that vary over time.
`sessionStarts` is incremented each time a connection event occurs.
`sessionEnds` is incremented each time a close event occurs.
All of the doing in our program is an attempt to confront time-varying value.
And all of the timer's behavior flows from that variance.
`sessionStarts` and `sessionEnds` should not be defined simply as "number".
They must be defined as "number that varies over time".

Functional reactive programming (FRP) is an approach to working with
time-dependent values.
FRP was first formulated by Conal Elliot and Paul Hudak in a paper that
proposed two abstractions: Behavior and Event.
Behavior and Event both model time-dependent values.
The difference between a Behavior and an Event is a distinction of _when_ the
value exists.

A Behavior exists always and an Event exists sometimes.
The classic example of this distinction is mouse position and mouse clicks.
There is always a current value of the mouse position but there is only a last
occurrence of the mouse click.
When the presence of value is unbroken over time, then the value is said to be
continuous.
Values that are not continuous over time are said to be discrete.
Behaviors are continuous over time and Events are discrete.

Our pausable timer problem contains examples of both Behaviors and Events.
The connection and close events are both discrete values over time.
The number of current connections is a continuous value over time.
The former have last occurrences.
The latter has a current value.
The most precise definition of these things would treat them as different types.

We are going to use one abstraction, the Observable, to represent both.
An Observable is a stream of discrete values over time, practically equivalent
to an Event.
Conflating continuous and discrete values is imprecise.
Nonetheless, we can model everything as an Observable and still manage to derive
the desired behavior.
With apologies to Elliot and Hudak, let's continue.

## III. Making time concrete

> ...events may be combined with others, to an arbitrary degree of
> complexity, thus factoring complex animation logic into semantically rich,
> modular building blocks.
>
> &mdash; Conal Elliot and Paul Hudak, [_Functional Reactive Animation_](http://conal.net/papers/icfp97/)

Our strategy is to replace instructions with definitions.
Definitions are expressed as functions, one value being defined as the function
of another value.
The pausable timer is a function of two time-dependent values: connection counts
and connection ends.
To define the timer, we must first define those values.

There is no ready-made Observable that counts opened and closed connections.
Those numbers are themselves functions of the `'connection'` and `'close'` 
events. 
RxJs provides a [`fromEvent`](https://rxjs-dev.firebaseapp.com/api/index/fromEvent) 
constructor that creates an event stream.
We can use `fromEvent` to create a stream of `'connection'` events emitted by 
the server: 

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
In our first iteration, the socket is exposed through the `connection` event
as the first argument to the event handler.
But now the `connection$` Observable is handling the event. 
How can we access the arguments to the event handler without an event handler?

As it happens, the Observable passes those values along to us.
The stream of `connection` events is really a stream of arguments to the event 
handler.
Each time the `connection` event occurs, the Observable pushes an arguments
array into the event stream.
So the socket for each connection is the first item of each array in the stream.
We can use [`map`](https://rxjs-dev.firebaseapp.com/api/operators/map) to 
transform that stream of arrays into a stream of sockets.

{% highlight javascript %}
const head = xs => xs[0];

const socket$ = connection$.pipe(map(head));
{% endhighlight %}

Now we might be tempted to map the sockets stream to a stream of close events:

{% highlight javascript %}
map((socket) => Rx.fromEvent(socket, 'close'))
{% endhighlight %}

But the result is a stream of streams, one stream for each socket.
And we want a single stream of close events instead.
So we should use [`flatMap`](https://rxjs-dev.firebaseapp.com/api/operators/flatMap).
`flatMap` merges all of the sub-streams into one stream of close events.

{% highlight javascript %}
const close$ = socket$.pipe(
  flatMap((socket) => Rx.fromEvent(socket, 'close')),
);
{% endhighlight %}

Again, we can count occurrences of the event by summing the stream.
This is one moment where the imprecision of using an Event to model a Behavior 
leads to unexpectedly complicated code.
`'close'` events have only a last occurrence and not a current value.
When no `'close'` event has occurred, then there is only an empty stream.
Observables naturally conform to this model of value over time.
But the close event count _should_ have a current value and Observables have no 
such concept.

The best we can do is set an initial value in the stream.
When no close event has occurred, then the value of the count should be zero.
To set that initial value, we merge the count stream with a stream of `0`.

{% highlight javascript %}
const zero$ = Rx.of(0);

const closeCount$ = Rx.merge(
  zero$,
  close$.pipe(scan(increment, 0))
);
{% endhighlight %}

We have defined our two fundamental time-dependent values: `connectionCount$` 
and `closeCount$`.
Now we can start to define the pausable timer as a function of those values.
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

Then the paused condition can be defined as a function of the current 
connections count.
The latest value in the stream should be `true` when the timer is paused and 
`false` when it is not.

{% highlight javascript %}
const isPaused = (count) => 1 > count;

const pause$ = currentCount$.pipe(map(isPaused));
{% endhighlight %}

Now that we know when to pause the timer, how do we pause it?
Recall that our first iteration did not truly pause the timer.
Instead, we created and destroyed timers whenever the paused state changed.
The latest timer instance was destroyed when the timer appeared to pause.
And a new timer instance was created each time the timer appeared to start.

Conceptually, this approach is sound and we can use [`switchMap`](https://rxjs-dev.firebaseapp.com/api/operators/switchMap) 
to do the same thing.
`switchMap` enables us to change the source of a stream's values.
When the pause condition is `false`, we'll switch the source from the timer 
to an Observable that never produces a value.
When the pause condition is `true`, we'll switch the source back to a timer.
`switchMap` automatically cleans up the timer each time we switch to the paused
state.

{% highlight javascript %}
const tick$ = pause$.pipe(
  switchMap(isPaused => isPaused ? Rx.NEVER : Rx.timer(0, 10000)),
  multicast(new Subject()),
);

// start execution of the multicast Observable
ticks$.connect();
{% endhighlight %}

All the instructions have been replaced with definitions.
We are freed from the mutable state trap.
Once again, the websocket session handler is free to observe the ticks stream
without knowing how it should behave or directing that behavior.

{% highlight javascript %}
server.on(`connection`, () => {
  tick$.subscribe({
    next: () => {
      // ...
    }
  });
});
{% endhighlight %}

<div style="margin: 0 0 1.5rem;" id="observables-explorable-1"></div>

<script src="https://static.maxhallinan.com/observables-explorable-1.js"></script>

<script>
  window.addEventListener('load', () => {
    window.ObservablesExplorable1.run('#observables-explorable-1');
  });
</script>
