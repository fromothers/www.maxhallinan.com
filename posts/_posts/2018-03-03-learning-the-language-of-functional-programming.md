---
layout: post
title: "Learning the Language of Functional Programming"
tags: [elm, programming]
---

Elm is a functional programming language that largely avoids the vocabulary of
functional programming.
Chatter about bifunctor and contramap seldom occur in the world of Elm.<sup><a id="ref-1" href="#cite-1">1</a></sup>
And though Elm's `Maybe` might be one instance of a "monoid in the category of
endofunctors", there is no concept of a monad in Elm.
Evan Czaplicki, Elm's creator, argues that the theory is not essential.<sup><a id="ref-2" href="#cite-2">2</a></sup>
Instead, Elm focuses programmers on concrete patterns for problem solving in the
domain of user interfaces.
It is possible for an Elm programmer to write an Elm program with little
awareness of the theory implied by their work.

This approach makes sense when the purpose is to teach user interface
development.
But I'm not sure it makes sense if the purpose is to teach functional
programming.
It should not be assumed that functional programming is the inevitable
result of programming in a functional language.
Functional programming and programming in a functional language are not the same
thing.
I do not need a functional programming language to do functional programming.
I only need a language with first class functions.
That means I can do functional programming in many more languages than those
that are commonly called "functional".

A language is called "functional" when the language lends itself to expressing
a certain kind of thought.
I have done functional programming when I have thought that way.
To the degree that Elm or Haskell or Clojure forces me into this way of
thinking, then proficiency with the language can amount to an understanding of
the subject.
But the act of functional programming remains in the thought.
User interface programming is one opportunity to demonstrate this way of
thinking.
But unless the thought is made explicit during the demonstration, understanding
only occurs incidentally.

In the way of thinking that is functional programming, a program is an arrow
between two points.
Both points are data types and the arrow between them is a transformation of one 
type to the other.
The arrow originates at the input point and ends at the output point.
Thus, a line-count program is an arrow from string to integer.

If one inspects the path of the arrow connecting input to output, one finds 
more arrows between more points.
A single arrow, like the arrow from input to output, is sometimes a 
"composition" of two arrows.
Two arrows compose when one arrow ends where the other begins.
Then there is said to be a single arrow between the start of the first arrow and 
the end of the second arrow.
Functional programming is largely about composing smaller arrows into bigger 
arrows until finally there is just one arrow between input and output.

Laws dictate the arrows that exist between every pair of points.
To connect two points, the functional programmer follows a law.
So functional programming can be understood only when the laws are understood.
If I write code in a functional language that applies laws I do not understand,
maybe I have been a productive programmer but I have not understood functional
programming.

What good is understanding the laws if I can be productive without this
understanding?
The question reminds me of eighth-grade Algebra I.
Eighth-grade algebra taught me some laws and taught me to apply those laws to
math problems.
Most laws came with calculation techniques, something like dividing a number on
the right side by a number on the left side.
The calculation technique was the method for applying the law to the problem
and students were tested on the result of the calculations.
Knowing the answer did not depend on knowing the law.
Success in Algebra I meant choosing the correct calculation technique and not
necessarily knowing the law that justified the choice.

Two groups of students emerged in that class.
The first group became skilled at memorizing which technique went with which
kind of problem.
This worked like a decision tree: if the details of the problem are like x, then
use y technique.
In that approach, the laws aren't essential information.
But the second group tried to abstract the details of the problem to the laws
first and then work out the numbers.
Perhaps students in the second group still used the prescribed technique but
they did so knowing why the technique was prescribed.

The decision tree was a limited form of understanding.
It only enabled a student to solve familiar problems.
Unfamiliar problems required an extension of the decision tree, even if the
solution simply used a new combination of familiar laws.
It was knowing the laws, not the decision tree, that empowered the students to
solve the unfamiliar problems.
And knowing the law meant that new applications of the law were less work to learn.
Sometimes I could make that shift on the fly, without having to study.
This reduced time spent on math outside of class and saved me more than once on
a test.

On paper, I resemble Elm's target audience.
My math education concluded early, in the third year of highschool and I nearly
failed that final year.
Nothing has changed since then.
I remain uncomfortable with numbers.
I know little about category theory and I can't define contramap.
But I am working to change this because I remember the usefulness of the
seemingly unuseful laws from eighth-grade algebra.

The promise of functional programming is that knowing the laws will make me a
more capable programmer just as it made me a more capable math student.
In this sense, the best functional programming language is the language of those
laws.
Whether or not I learn the laws through the use of a programming language,
I must learn the laws to learn functional programming.
The argument remains that the theory can be learned later, after learning the
techniques.<sup><a id="ref-3" href="#cite-3">3</a></sup>
I suppose this is true.
But I wonder how an Elm programmer is ever made aware of the theory.
How can the language make me aware when it avoids the subject?
It is not necessarily the responsibility of the language to convey the theory to
the programmer.
Nonetheless, I am best served as a student of functional programming by a
language that exposes me to those concepts.

**Notes**

<ol>
  <li>
    <fn id="cite-1">
      <blockquote>
        <p>
          How close is the Redux connect() function to a Bifunctor (see Fantasy 
          Land for details) ? Honest question. Could it have been designed with 
          bimap somehow?
        </p>
        &mdash;
        <a href="https://twitter.com/andrestaltz/status/956241231541161984">
          @andrestaltz
        </a>
      </blockquote>
      <blockquote>
        <p>
          Seems like a contramap to me. So a contravariant bifunctor abstracting 
          the connect function itself as a builder
        </p>
        &mdash;
        <a href="https://twitter.com/drboolean/status/956291210221518848">
          @drboolean
        </a>
      </blockquote>
    </fn>
    <sup>
      [<a href="#ref-1">Return</a>]
    </sup>
  </li>
  <li>
    <fn id="cite-2">
      <blockquote>
        <p>
          ...you can essentially be very active using monadic things without 
          ever talking about it.
        </p>
      &mdash;
      <a href="https://youtu.be/oYk8CKH7OhE?t=27m38s">
        Evan Czaplicki
      </a>
      </blockquote>
    </fn>
    <sup>[<a href="#ref-2">Return</a>]</sup>
  </li>
  <li>
    <fn id="cite-3">
      <blockquote>
        <p>
          You can design the language such that as someone gets started and gets 
          productive, slowly they realize these concepts in a way that builds 
          upon each other in a way that works for people.
        </p>
        &mdash;
        <a href="https://youtu.be/oYk8CKH7OhE?t=15m32s">
          Evan Czaplicki
        </a>
      </blockquote>
    </fn>
    <sup>[<a href="#ref-3">Return</a>]</sup>
  </li>
</ol>
