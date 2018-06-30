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

<!--
Knowing how to pause the timer is a matter of being able to start and stop the
timer repeatedly.
First let's create a function that returns the timer Observable.

It's important to note that the timer will continue to run as the number of
current connections advances beyond 1.
The stopping and starting only happens in the vicinity of 1.

Know that we know when to pause the timer, we can think about how to pause the
timer.
We're using a timer Observable.

- we're already managing two pieces of global mutable state just to know when to
  start and stop the timer
- as we move on to pausing the timer, things will get even more complex
- state management will get more complex
- the amount of "how to do it logic" will get more complex
- add imperative logic

We are using global state to spread information across isolated contexts.

Every websocket connection must be prepared to pause the timer.
Each connection must be aware of the other connections, specifically the
number of current connections.

Because every websocket connection must be prepared to pause the timer, each
connection must be aware of the other connections, specifically the number of
current connections.

Every websocket connection must be prepared to pause the timer.
Knowing when to pause the timer requires each connection to know the number of
current connections.


Global state makes it possible for all connections to be aware of each other in this way.
Each connection is isolated from the other connections but all connections have
access to the global context.


Global state enables each connection, isolated in its own context, to access
this information.



What are we doing with global state?
We are using






Each websocket connection is prepared to pause the timer.
k
A connection is able to pause the timer at the correct moment because it is
aware of the number of current connections.
The number of current connections is information shared by all connections.
Because

They know when to pause the timer by sharing information about the number of
current connections.

Each websocket connection is be prepared to pause the timer.
Knowing when to pause the timer requires each connection to know the number of
current connections.
For each connection to be aware of other connections,
Knowing when to pause the timer requires each connection to know the number of
current connections.
For each connection to be aware of other connections,

So each connection must have some awareness of other connections.

Specifically the total number of current connections
Global mutable state gives each websocket connection this g
To be aware of each
each connection to be globally aware,
specifically to know the number of current connections.

The conditions pausing the timer require an awareness of other connections,.


The websocket connections are responsible for starting and stopping the timer.
To start and stop the timer, each websocket connection must have some awareness
of the other connections, specifically the total number of current connections.
Global mutable state gives each websocket connection this global awareness.


Our need to share information with the otherwise encapsulated websocket
connections has forced us to add two pieces of global mutable state.
All websocket connections share two pieces of global state.

So all websocket connections share two pieces of global state.

The first part of the problem has been completed by using t
sharing two pieces of global


We added two pieces of global mutable state just to know when to pause the
timer.
To know when to pause the timer, we added to pieces of global mutable state.

So we've added two pieces of global mutable state.
The state is shared by the websocket connections.
The websocket connections are unaware of each other.
Logic for the websocket connections is trapped in the closure of the `connection`
event handlers.
The state has been placed in the global scope because each connection must
be able to read and update that state.
The socket sessions, because they are closures, are unaware of each other.
The state is global because it has to be shared by each open connection.
Now we turn to the second part of the problem: knowing how to pause the timer.
Starting and stopping the timer will require additional global mutable state.

We've added two pieces of global mutable state.
Now we will add more global mutable state to implement the pausable timer.
-->

<!--
Polling the MTA feeds essentially means starting a timer.
In both cases, a function is called every 30 seconds.
The primary difference is that a timer produces a "tick", which could be a value
like `1` or `undefined`, and the polling function produces new MTA feed data.
We're not concerned with the data itself.
So let's simplify "polling the MTA feeds every 30 seconds" to a timer that ticks
every 30 seconds when there are open websocket connections and does not tick
when there are none.
For details about this timer and the Observable pattern, please read the
previous post.

The problem we want to solve is not polling on demand in general but
specifically polling on demand _without mutable state_.
How tricky is this problem?

Sometimes the complexities of a problem are best understood by failing to solve
the problem.
Let's use my first attempt, the attempt that
Sometimes a problem is best understood through making mistakes, by doing failing
to solve it first in order to understand why must be done to solve it successfully.
Let's use my first attempt, the attempt that does use mutable state, to reveal
the complexities of the problem.
For an answer to that question, let's look at my first attempt to build this
feature, the approach that uses mutable state.

Polling the MTA feeds essentially means starting a timer.
In both cases, a function is called every 30 seconds.
The primary difference is that a timer produces a "tick", which could be a value
like `1` or `undefined`, and the polling function produces new MTA feed data.
We're not concerned with the data itself.
So let's simplify "polling the MTA feeds every 30 seconds" to a timer that ticks
every 30 seconds when there are open websocket connections and does not tick
when there are none.
-->

<!--
make a note about the timer being a concept re-used from the last blog post
don't want

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
<!--
I like to collect the problems that patterns solve, patterns like polling on
demand.
The problems solved by a pattern are key to understanding that pattern.
And I like problems from experience more than problems contrived for
instruction.
The usefulness of a pattern is best evoked by a real problem.
So here I am again to write about the Observable pattern, to again note
its usefulness.
-->

<!--
Am I simply indulging my affection for the Observable pattern or does it provide
improve the code?
value?
Is the Observable pattern here a bit of over-engineering?
-->
<!--
The problem catalogue
- interesting if technical writing, technical ideas were always presented in the
context of real problems solved, problems from experience
- a catalogue of problems from experience
- a log book of problems solved, like a lab book maybe
-->

<!--
In an early paper about functional reactive programming called "Functional
Reactive Animation", Conal Elliot presented a concept called an Event.
An Event was essentially a function of Time.
that was that could be


> ...events may be combined with others, to an arbitrary degree of
> complexity, thus factoring complex animation logic into semantically rich,
> modular building blocks.

applied to the domain of
animation
-->
