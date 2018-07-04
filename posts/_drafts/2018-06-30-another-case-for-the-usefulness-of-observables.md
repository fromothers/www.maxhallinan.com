---
layout: post
published: true
title: "Another case for the usefulness of Observables"
tags: [javascript, programming]
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
incremented by the `connection` and `close` event handlers.

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
`current connections = opened connections - closed connections`.
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

Now we need the pausable timer itself.
Recall that Observables and Generators are both functions that produce one or
more values.
A Generator is easily paused.
In fact, the execution of a Generator is suspended each time a value is
produced.
Execution resumes only when the caller asks for the next value.
But an Observable behaves differently.
While consumers pull values from Generators, Observables push values out to
consumers.
This means that the consumer does not determine when the value is produced and
so cannot suspend execution of the Observable.

This would be a problem if the pausable timer required a continuous execution
context.
Continuous context is required only when the paused computation needs to resume
from its last state.
For example, a pausable function that counts infinitely up from one should
preserve its execution context:

```
1 2 3 pause 4 5 6
---------------->
```

If the context is not preserved, pausing the function will reset the count:

```
1 2 3 pause 1 2 3
---->       ---->
```

This counter function should be modeled as a Generator and not an Observable.
But our pausable timer (and polling) does not require this kind of context
preservation.
Instead, we can start a timer when we need one and dispose of it when we don't.

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

To start the pausable timer for the first websocket connection, we simply
create a new timer Observable and start the execution of that Observable by
calling `connect`.
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

When the last connection closes, the timer is disposed by calling
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

## Being instead of doing

> For me, functional programming is not about doing. It's about being.

&mdash; Conal Elliot ["The Essence and Origins of Functional Reactive
Programming"](https://www.youtube.com/watch?v=j3Q32brCUAI&feature=youtu.be&t=4m21s),
Lambda Jam 2015

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
We have defined them as numbers.
The problem is that the value of those numbers varies over time.
<!--The problem is that these are numbers whose values vary over time.-->
<!--They are defined as numbers-->
<!--The problem is that the values of those numbers vary over time-->
`sessionStarts` is incremented each time a `connection` event occurs.
`sessionEnds` is incremented each time a `close` event occurs.
<!--And the timer's behavior flows from the variance in those two values.-->
All of the doing in our program is an attempt to confront time-varying value.
And all of the timer's behavior flows from that variance.
`sessionStarts` and `sessionEnds` should not be defined simply as "number" but
as "number that varies over time".

<!--
All of the doing in our program is an attempt to confront the time-varying 
property of these values.

To be about being instead of doing, we should define time-varying values as a
thing and not imply them as an effect of our logic.
-->

Create a `connection` event stream.

{% highlight javascript %}
const Rx = require(`rxjs`);
const { map, } = require(`rxjs/operators`);

const head = xs => xs[0];

const socket$ = Rx.fromEvent(server, `connection`).pipe(map(head));
{% endhighlight %}

Sum the number of `connection` events.

{% highlight javascript %}
const Rx = require(`rxjs`);
const { map, scan, } = require(`rxjs/operators`);

// ...

const add = (n1) => (n2) => n1 + n2;

const increment = add(1);

const connectionCount$ = socket$.pipe(scan(increment, 0));
{% endhighlight %}

Create a close event stream.
Introduce `flatMap`.

{% highlight javascript %}
const { flatMap, map, scan, } = require(`rxjs/operators`);

const close$ = socket$.pipe(
  flatMap((socket) => Rx.fromEvent(socket, `close`)),
);
{% endhighlight %}

Sum the number of close events.

{% highlight javascript %}
const zero$ = Rx.of(0);

const closeCount$ = Rx.merge(
  zero$,
  close$.pipe(scan(increment, 0))
);
{% endhighlight %}

Count the number of current connections.

{% highlight javascript %}
const subtract = (x, y) => x - y;

// the current number of open sockets
const activeCount$ = Rx.combineLatest(
  [ connectionCount$, closeCount$, ],
  subtract
);
{% endhighlight %}

Define the condition for pausing the timer.
Emphasize that we're moving logic out of the connection handler.
The goal is a logic-less connection handler, one that doesn't know if the
timer is paused or not.
Doesn't know that the timer can be paused.
Doesn't need to know about any of the other connections.

{% highlight javascript %}
const isPaused = (count) => 1 > count;

const pause$ = activeCount$.pipe(map(isPaused));
{% endhighlight %}

When the timer is paused, switch to an Observable that never produces a value.
When the timer is not paused, switch to a new instance of the timer.
Introduce `switchMap`.
Introduce `Rx.NEVER`.

{% highlight javascript %}
const tick$ = pause$.pipe(
  switchMap(isPaused => isPaused ? Rx.NEVER : Rx.timer(0, 10000)),
  multicast(new Subject()),
);
{% endhighlight %}

Use pausable timer in the websocket session.

{% highlight javascript %}
server.on(`connection`, () => {
  tick$.subscribe({
    next: () => {
      // ...
    }
  });
});
{% endhighlight %}
