---
layout: post
published: true
title: "Another case for the usefulness of Observables"
tags: [javascript, programming]
---

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
