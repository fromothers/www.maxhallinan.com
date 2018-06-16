---
layout: post
published: true
title: "Another case for the usefulness of Observables"
tags: [javascript, programming]
---

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
