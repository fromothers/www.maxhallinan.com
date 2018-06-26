---
layout: post
published: true
title: "Another case for the usefulness of Observables"
tags: [javascript, programming]
---

I recently [wrote](/posts/2018/06/02/changing-state-over-time-without-mutation/)
about a websocket server that tracks the current location of trains in the New
York City subway.
The server polls the MTA's real-time data feeds every 30 seconds.
My last post failed to acknowledge a design flaw.
The server is _always_ polling, every 30 seconds, even when no one is listening.
The latest data from the MTA is discarded when there are no open websocket
connections.
So bandwidth is wasted and unnecessary load is placed on a free service.
Better to poll the MTA feeds only when the data is in demand.

Polling on demand gets messy fast.
My naive first attempt made liberal use of mutable state.
And once again, the Observable pattern freed me from that trap.
I like to collect the problems that patterns solve, patterns like polling on
demand.
The problems solved by a pattern are key to understanding the pattern.
And I like problems from experience more than problems contrived for
instruction.
The usefulness of a pattern is best evoked by a real problem.
So here I am again to write about the Observable pattern, to again note
its usefulness.

The problem we're examining here is not polling on demand in general but
specifically polling on demand _without mutable state_.
How tricky is this problem?
Did I use the Observable pattern or was I just indulging myself?
<!--
Am I simply indulging my affection for the Observable pattern or does it provide
improve the code?
value?
Is the Observable pattern here a bit of over-engineering?
-->
For an answer to that question, let's look at my first attempt to build this
feature, an approach that uses mutable state.

Polling the MTA feeds is essentially a matter of starting a timer.
A function is called every 30 seconds.
The primary difference is of the data produced by the function.
A timer produces a "tick", which could be a value like `1` or might be 
`undefined`.
The polling function produces new data from the MTA feed.
For our topic, a timer and a polling interval are equivalent.
So let's abstract "polling the MTA feeds every 30 seconds" to a timer that ticks
every 30 seconds when there are open websocket connections and does not tick 
when there are none.

<!--
make a note about the timer being a concept re-used from the last blog post
don't want 
-->

This feature has two parts:

- a pausable timer;
- knowing when to pause the timer.

Both parts provide a starting point for understanding the usefulness of 
Observables.

To create a pausable timer,

{% highlight javascript %}
let tick$ = null;

const createTick$ = () => {
  //...
};

server.on(`connection`, () => {
  if (!tick$) {
    tick$ = createTick$();
  }

  ticks$.subscribe({
    next: sendMsg,
  })
});
{% endhighlight %}
<!--
Polling on demand without mutable state is the problem.

To answer that question, let's look at what I consider to be the most obvious or
straightforward solution, a solution that uses mutable state.

Before we look at the solution, let's look at a naive solution that uses
uses mutable state to understand the problem.
mutable state to i

The problem we're examining here is not polling on demand in general but
specifically polling on demand without mutable state.

It sometimes helps to start with a naive solution.
Do it first in the way that is the most obvious.
Sometimes that is enough.
The obvious way need not be naive.
When it is naive, it nonetheless uncovers complexity and

And when it is naive, it is nonetheless a good way to understand the problem,
to uncover complexities and investigate potential for abstraction.

  - the naive solution is often a good way to understand the problem, find the
    complexities and reveal areas where abstraction is helpful
And sometimes the obvious way works to reveal the complexities and areas that
would benefit from abstraction.

  - as was the case in the last article, we can achieve our goal naively with
    global mutable state
-->


<!--
- background
  - websocket server
  - polls the MTA every 5 seconds
  - transforms the MTA feed data into a description of train locations
  - sends a message describing the current train locations to each open
    websocket connection
- problem
  - consuming unnecessary bandwidth
  - driving up operating cost unneccessarily
  - irresponsible use of a free service
- solutions
  - each websocket connection independently polls the MTA feeds
      - when there are no connections, no polling happens
      - problem: duplicates work
      - problem: scales poorly
      - problem: consumes exponentially more resources than required
  - start polling when there is one or more open connections and stop polling
    when there are no open connections
- it helps to start with a naive solution
  - the naive solution is often a good way to understand the problem, find the
    complexities and reveal areas where abstraction is helpful
  - as was the case in the last article, we can achieve our goal naively with
    global mutable state

```javascript
let tick$ = null;

const createTick$ = () => {
  //...
};

server.on(`connection`, () => {
  if (!tick$) {
    tick$ = createTick$();
  }

  ticks$.subscribe({
    next: sendMsg,
  })
});
```
        - this would work but we want to avoid mutable state and especially
          global state that is shared and updated by different contexts
          (websocket sessions)
  - there are broadly two problems:
    - mutable global state is messy and bug prone
    - there is a lot of imperative logic
    - generates a lot of cognitive overhead
    - it's hard to test
- why is this a good use-case for observables?
    - removes global state
    - enables us to think more simply
    - applies transformations to a stream of values
    - enables functional programming
- why is using observables better than using the naive approach?
  - what is it exactly that the observable abstraction does?
  - what does an observable represent?
  - are observables simpler?
  - in some sense, they are not
  - using an observable requires the user to learn some new ideas
  - the argument for observables is essentially the argument for functional
    programming
      - code that is easier to test
      - code that is easier to reason about
      - code that is less prone to regressions
  - in the most basic understanding of functional programming you transform a
    value a to a value b.
  - a function is the transformation
  - you can then compose a -> b to make a transformation of a -> b -> c.
  - in this way, you can use functions to describe complex transformations
  - but a perhaps overlooked assumption is that you
  - you can even transform a collection of values by representing that collection
    as itself a single value like an array
  - the implicit assumption of functional programming is that you have all the
    values you expect to have at the moment you transform them
  - if you want to sum a collection of numbers, you first get _all_ the numbers
  - but what if that assumption is incorrect?
  - what if the collection of numbers changes, grows over time?
  - if we think of the total number of connection events as simply summing an
    array of `1`s, where each 1 represents a `connection` event, then we have to
    re-calculate the sum each time an event occurs.
  - functional programming, in it's essence, assumes static values
  - transformations of static values
  - the basics of functional programming don't really help us here
  - observables give us a way to treat a series of values that are ordered in time
    as a static value
  - the observable abstracts the bits about updating the collection each time a
    new value is produced and re-running the transformations of that value
    downstream.
  - but what if the entire set of values grows over time?
  - observables facilitate the application of functional programming to a series
    of values ordered in time
  - ordered in time does not mean that the values are produced asynchronously
  - the observable might produce the entire series synchronously
      - for example, an observable oneThroughFive might call `next` five times
      - each call to `next` is a separate moment in time, regardless of whether
        the value passed to next was produced by a synchronous or asynchronous
        computation
- the naive approach expresses these kinds of thoughts:
  - "when there is a new websocket connection, check if a timer has already been
    created"
  - "when there is a new websocket connection, increment a connections counter"
  - "if there is no timer, create a timer"
  - "when there is a new websocket connection, decrement the connections counter"
  - "when a websocket connection closes, check if that was the last open
    connection"
- these kinds of thoughts are characterized as "actions to take"
  - they are instructions
- these instructions describe how to reach certain states
  - these states are:
    - "number of opened connections"
    - "number of closed connections"
    - "number of active connections"
    - "paused polling"
    - "active polling"
- states are static values
- static values are easier to think about
- we'd like to just transforming static values into static values
- instead of thinking in terms of actions, we can think in terms of the states
  - states are just values
  - a state is not an action or an instruction,
  - the value 1 does not describe any movement or change
  - states are produced by changes
  - focus on the states first and de-emphasize the actions that result in those
    states
  - "the number of connection events"
  - "the number of close events"
  - "the number of active connections"
- implementation with observables
  - components
    - tracking open connections
        - count the number of `connection` events
        - count the number of `close` events
        - `active connections count = total connections count - total closes count`
    - pausable polling
        - each session is given a feeds data source
        - each session subscribes to this data source
        - each time the data source produces new data, the session sends a new
          websocket message.
        - want to maintain this interface
        - want to do this without sideeffects
        - the data source must be passed to each new session
        - so the data source is defined outside of the scope of a `connection`
          event handler
        - to start a new poller for the first connection would require a sideeffect
          in order to pass that poller to subsequent sessions:

A timer that only ticks when someone has connected to the server.

{% highlight javascript %}
const Rx = require(`rxjs`);
const {
  flatMap,
  map,
  scan,
} = require(`rxjs/operators`);

const WebSocket = require(`ws`);

const server = new WebSocket.Server({ port: 8080, });
const socket$ = Rx.fromEvent(server, `connection`).pipe(map(head));

const connectionCount$ = socket$.pipe(scan(increment, 0));

const close$ = socket$.pipe(
  flatMap((socket) => Rx.fromEvent(socket, `close`)),
);

const zero$ = Rx.of(0);

const closeCount$ = Rx.merge(
  zero$,
  close$.pipe(scan(increment, 0))
);

const subtract = (x, y) => x - y;

// the current number of open sockets
const activeCount$ = Rx.combineLatest(
  [ connectionCount$, closeCount$, ],
  subtract
);

// stop polling when there are no open connections
const isPaused = (count) => 1 > count;

const isPaused$ = activeCount$.pipe(map(isPaused));

const createTimer = () => Rx.timer(0, 1000);

const pausableTimer = pauser.pipe(
  switchMap(isPaused => isPaused ? Rx.NEVER : createTimer())
);

pausableTimer.subscribe({
  next: () => {
    console.log(`tick`);
  },
});
{% endhighlight %}
-->
