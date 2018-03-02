---
layout: post
title: "Learning the Language of Functional Programming"
tags: [elm, programming]
---

Elm is a functional programming language that largely avoids the vocabulary of
functional programming.
Debates about contramap versus contravariant bifunctor seldom occur in the world 
of Elm.
And though Elm's `Maybe` might be one instance of a "monoid in the category of 
endofunctors", there is no concept of a monad in Elm.
Evan Czaplicki, Elm's creator, argues that the theory is not essential.
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
Nor does a functional language necessarily prohibit me from imperative 
programming.
Nothing prevents me from writing this Elm code:

```
```

A language is called "functional" when the language lends itself to expressing 
a certain kind of thought.
You have done functional programming when you have thought that way.
To the degree that Elm or Haskell or Clojure forces you into this way of 
thinking, then proficiency with the language can amount to an understanding of
the subject. 
But the act of functional programming remains in the thought. 
User interface programming is one opportunity to demonstrate this way of 
thinking.
But unless the thought is made explicit during the demonstration, an 
understanding of that thought can only occur incidentally.

In the way of thinking that is functional programming, a program is an arrow 
between two points.
Points abstract values and arrows abstract transformations.
An arrow between two points transforms one value into the other.
When two arrows connect three dots, `a -> b -> c`, then there is said to be an
arrow between `a` and `c`.
Functional programming is largely the game of abstracting smaller arrows to 
larger arrows until finally there is just one arrow transforming input to 
output.

Laws dictate the arrows that exist between every pair of points.
To connect two points, the functional programmer follows a law.
Functional programming is applying laws to problems. 
So functional programming can be understood only when the laws are understood.
If I write code in a functional language that applies laws I do not understand, 
maybe I have been a productive programmer but I have not understood functional 
programming.

So what good is understanding the laws if I can be productive without this 
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

That year, two groups of students emerged.
The first group became skilled at memorizing which techniques went with which 
kinds of problems.
This worked like a decision tree: if the details of the problem are like x, then 
use y technique. 
In that approach, the laws aren't essential information.
The second group tried to abstract the details of the problem to the laws first 
and then work out the numbers.
Perhaps students in the second group still used the prescribed technique but 
they did so knowing why that technique had been prescribed.

The decision tree was a very limited form of understanding. 
It only enabled a student to solve familiar problems.
Unfamiliar problems required an extension of the decision tree, even if the 
solution simply used a new combination of familiar laws.
It was knowing the laws, not the decision tree, that empowered the students to 
solve these problems.
Knowing the law meant that new applications of the law were less work to learn.
Sometimes I could make that shift on the fly, without having to study.
This reduced time spent on math outside of class and saved me more than once on 
a test.

On paper, I resemble Elm's target audience.
My math education concluded early, in the third year of highschool and I nearly
failed that final year.
Nothing has changed since then.
I remain uncomfortable with numbers.
I know little about category theory and I don't know the difference between a 
contramap and a bifunctor.
But I am working to change this, not because I want to join a pissing contest 
but because I remember the usefulness of the seemingly unuseful laws from eighth 
grade algebra.

The promise of functional programming is that knowing the law makes me a more 
capable programmer just as it made me a more capable math student.
In this sense, the best functional programming language is the language of those
laws.
Whether or not I learn the laws through the use of a programming language, 
I must learn the laws to learn functional programming.
The argument remains that the theory doesn't have to come first.
I suppose this is true.
But I wonder how an Elm programmer is ever made aware of the theory.
How can the language make me aware when it avoids the subject?
It is not necessarily the responsibility of the language to convey the theory to
the programmer.
Nonetheless, the language must do so if it claims to be a useful tool for 
teaching functional programming.
