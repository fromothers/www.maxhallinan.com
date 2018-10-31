---
layout: post
published: true 
title: "Little Languages"
tags: [programming]
---

## I.

Programming languages are collections of ideas.
Learning a programming language means learning to apply the ideas found in the
language.
But sometimes it is hard to isolate the ideas.

Language details might obscure ideas in the language.
For example, some typeclasses in Haskell obey some algebraic laws.
Because I was exposed to those typeclasses first, I expected this to be true of 
every typeclass.
I misunderstood the idea of a typeclass as a way to group types by laws.

I had actually come into contact with two ideas.
First, types can be grouped by operations on those types.
Second, _sometimes_ those groups are principled.
Only the first is essential to the idea of a typeclass.
Because of the frequent coincidence of both ideas in Haskell, I didn't perceive
them as separate ideas.

## II.

Learning a programming language means learning a set of ideas.
But sometimes the details of the language obscure the ideas.
Then it might be helpful to engage with the ideas first outside of the language.
The programming language as a set of ideas could be decomposed to a little
language for each idea.

A little language would not be used for general purpose programming.
It would not replace large languages, those languages that are sets of ideas.
When encountering a new idea in a large language, I could reach for the little
language of that idea.
Then I would return to the large language when I had gained an intuition for
applying that idea.

[Isla](http://islalanguage.org/) is a little language, a language for the idea
of modeling data.
There are only a few functions in Isla, none that are defined by the user.
The language has no control flow, no booleans, no numbers.
An Isla programmer defines things like shapes, planets, or people, and describes
those things by giving them attributes.

Using objects to model entities is a practice found in many languages.
Programming in Isla yields an intuition for this practice that can be ported to 
any large language.

## III.

There is a [room](https://www.deutsches-museum.de/en/exhibitions/communication/mathematics/) 
in the Deutsches Museum that is filled with unusual toys.
Some are blocks that fit together like puzzles.
Others have strange forms that cause the object to roll in unexpected ways.

Each toy models a mathematical idea.
The toy makes the idea concrete.
Playing with the toy yields an intuition for the idea.
With those toys, one can say 
"Here's how tetrahedra combine to form a cube. Here's how the oloid rolls."

I wish for more computer languages like those toys. 
I want to play with an outer join without installing and provisioning a 
database.

# IV.

But I'm skeptical that there can be little languages.
Do the ideas in programming languages have Platonic forms that can be isolated 
in languages of their own?

A little language for typeclasses would need to include other ideas.
The idea of a typeclass depends on the idea of types.
Some typeclasses imply the idea of type kinds.
Is it possible to play with these ideas without a fully-featured language?

And a little language should be interesting to interact with.
The toys at the Deutsches Museum behave in curious ways.
That behavior draws the visitor into the mathematical insight.
It's not clear to me that a language devoted to a single idea would do much of 
anything.

# V.

When Daniel Friedman and David Christiansen sought to explain dependent types, 
they did not point to a dependently typed language like [Idris](https://www.idris-lang.org/).
Instead, they designed a "very small language" called [Pie](https://github.com/the-little-typer/pie).
Pie exists just for the purpose of explaining dependent types.

We programmers produce a lot of commentary.
This commentary takes the form of blog posts and books, talks and workshops.
We consume this commentary in part to understand ideas found in programming 
languages.
Perhaps it would be interesting to design more languages for this purpose.
