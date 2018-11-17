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

What makes user interface code easy to understand?
In his paper ["Explicitly Comprehensible Functional Reactive Programming"](https://futureofcoding.org/papers/comprehensible-frp/comprehensible-frp.pdf), 
Steven Krouse argues that a cyclic graph of sub-state streams is superior to the 
Elm architecture, which is oriented around a single stream of states.
I understand Steven's argument in favor of de-composing Elm's monolithic state
stream as being primarily about enabling local reasoning about transformations
of those substates.
To understand all transformations of any given substate in the Elm architecture
requires reasoning across a broader context.
All state transitions can produce a new value for any piece of state.
The arguments that Steven gives
{% comment %}
event to state transitions.
{% endcomment %}
Steven finds the de-composition of Elm's monolithic state stream to be superior
because it enables location of all transformations of any sub-state in a single
place.

But in practice, one rarely has to consider all state transitions.
I have rarely had to consider all transitions of a given substate at the same 
time.
Removing that piece of state is the only time I've had to do that.
What I do think about a lot is _what caused_ a piece of state to change.

smaller streams to be superior because it 
enables one to locate all transformations of any sub-state in a single place.

A programmer working with the Elm architecture must consider all state 
transitions if she wants to know every location where a sub-state changes. 



To answer the question "when does this sub-state change" in the Elm architecture 
requires one to audit the transformations that occur for every event handled by
the application.

the superiority of the cyclic graph is found in the ability to locate all
transformations of a given state in a single place.

composing small streams of states into larger streams
of states is a most "comprehensible" mental model for user interfaces.
This gr
He places this primarily in contrast to the Elm architecture, which is oriented
around a global stream of event to state transitions.
I disagree with Steven's conclusions and feel that, in general, that an answer 
to this question is better reasoned from experience than formulated in the 
abstract.


I've been thinking about 
I've been thinking about the qualities of codebases I find easy to understand.
I disagree with most of Steven's conclusions. 
The paper does not do enough to defend it's assertions with evidence from 
experience.

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
