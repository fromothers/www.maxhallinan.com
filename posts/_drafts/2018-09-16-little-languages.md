---
layout: post
published: true 
title: "Little Languages"
tags: [programming]
---

Programming languages are collections of ideas.
Learning a programming language means learning to apply the ideas found in the
language.
But sometimes it is hard to isolate the ideas.

<!--Language details can cloud perception of the ideas in the language.-->
Language details can obscure ideas in the language.
For example, many common typeclasses in Haskell are described by algebraic laws.
After exposure to these typeclasses, I misunderstood the idea of a typeclass as 
a way to group types by the laws they obey.

I had actually come into contact with two ideas.
First, types can be grouped by operations on those types.
Second, _sometimes_ those groups are principled.
Only the first is essential to the idea of a typeclass.
Because of the frequent coincidence of both ideas in Haskell, I didn't perceive
them as separate ideas.

So learning a programming language means learning a set of ideas.
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

The little language need not be specific to any single large language.
Using objects to model entities is a practice found in many languages.
Programming in Isla yields an intuition for this practice that can be ported to 
any large language.

{% comment %}
- A lot of the understanding of programming languages is an intuitive
  understanding of how to apply the ideas, a feel for how they work.
- You should be able to use the language to do something. There should be some
  interesting outcome of using the language, just as LOGO was used to instruct
  the Turtle to draw pictures.
- So you could have a whole toy chest of these little languages.
{% endcomment %}
