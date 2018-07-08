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

## II. Being instead of doing

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
We have defined them as numbers but they are numbers that vary over time.
`sessionStarts` is incremented each time a `connection` event occurs.
`sessionEnds` is incremented each time a `close` event occurs.
All of the doing in our program is an attempt to confront time-varying value.
And all of the timer's behavior flows from that variance.
`sessionStarts` and `sessionEnds` should not be defined simply as "number".
They must be defined as "number that varies over time".

Functional reactive programming (FRP) is an approach to working with time-based 
values.
FRP was first formulated by Conal Elliot and Paul Hudak in a paper that 
proposed two abstractions: Behavior and Event.
Behavior and Event both model time-based values.
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
The `connection` and `close` events are both discrete values over time.
The number of current websocket connections is a continuous value over time.
The former have last occurrences.
The latter has a current value.
The most precise definition of these things would treat them as different types.

We are going to use one abstraction, the Observable, to represent both.
An Observable is a stream of discrete values over time, practically equivalent
to an Event.
By conflating continuous and discrete values, we are going to be imprecise.
Nonetheless, we can model everything as an Observable and still manage to derive
the desired behavior.
With apologies to Elliot and Hudak, let's continue.

## III. Making time concrete

> ...events may be combined with others, to an arbitrary degree of
> complexity, thus factoring complex animation logic into semantically rich,
> modular building blocks.

&mdash; Conal Elliot and Paul Hudak, [_Functional Reactive Animation_](http://conal.net/papers/icfp97/)

Our first iteration of the pausable timer identified several time-dependent 
values:

- number of open connections
- number of closed connections
- number of currently open connections

These values were used to detect when to pause the timer.
Our first step will be to express this condition as an Observable.
We can start by defining the smallest components of this condition.
Then we can combine those components.

<!--
- Observables represent a timeline of value occurrences
- In the first approach, the timeline was implied
- The code checked for conditions that defined the occurrence and then responded
  to that occurrence.
- There was no thing that is these occurrences.
- An Observable is the timeline
- The Observable makes the timeline concrete
- The Observable makes a timeline of value occurrences into a concrete thing 
  like a number or a string.
- Making time concrete is useful because then you can combine things into more
  complex things.
- What are we doing in this section?
- What is the theme of this section?
- We need to start solving the problem.
- We know what are abstraction is and why we need to use it 
- We know we need to abstract time-dependent value.
- We know we are going to use Observables to represent time-dependent values.
- We know that our timer is already a variable.
- We know that the state of the timer depends on some other time-dependent 
  values.
- How do we go from time-dependent states to a timer?
- What are the time-dependent values involved in the pausable timer behavior?
  - total opened websocket connections
  - total closed connections
  - total current connections
  - the no current connections state
  - the paused state
  - the timer itself
- most of these values are functions of other values
- most of these values are derived from other values
-->

Representing value over time as a "thing" makes time concrete.
Making time concrete is useful because concrete things can be combined with 
other concrete things to make more concrete things.

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
