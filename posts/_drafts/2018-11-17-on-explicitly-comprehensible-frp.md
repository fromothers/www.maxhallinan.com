---
layout: post
title: "Response to \"Explicitly Comprehensible Functional Reactive Programming\""
tags: [programming]
---

<blockquote>
  <p>
    While Reflex enables understanding <em>states</em> via a single place in the code, 
    Elm enables understanding <em>messages</em> via a single place in the code.
  </p>

  <cite>
    &mdash; Steven Krouse, <a href="https://futureofcoding.org/papers/comprehensible-frp/comprehensible-frp.pdf"><em>Explicitly Comprehensible Functional Reactive Programming</em></a>
  </cite>
</blockquote>

My heuristic for the "comprehensibility" of an unfamiliar codebase is the ease 
with which I can debug it.
Debugging tests my ability to reason about the system.
Unfamiliar code that has been quickly debugged is code that has been quickly 
understood.

A bug in a user interface can have roughly two causes: there is an incorrect 
state 

there is a correct state
that has been displayed incorrectly or there is an incorrect state.

Debugging user interfaces 
Unfamiliar code that is quickly debugged is code that has been quickly 
understood.
Debugging user interfaces tends to be a test of how quickly I can answer two 
questions: what is the bad state and how was that state produced.
