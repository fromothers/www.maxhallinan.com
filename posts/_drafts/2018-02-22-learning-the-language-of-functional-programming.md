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
For example, nothing prevents me from writing this Elm code:

{% highlight elm %}
type alias Named =
    { name : String
    }


updateName : String -> Maybe Named -> Maybe Named
updateName name mNamed =
    case mNamed of
        Just named ->
            Just { named | name = name }

        Nothing ->
            Nothing
{% endhighlight %}

instead of something like this:

{% highlight elm %}
updateName : String -> Maybe Named -> Maybe Named
updateName name =
    Maybe.map (\named -> { named | name = name })
{% endhighlight %}

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
The arrow originates at the point called "input" and ends at the point called 
"output". 
Each point is a value. 
An arrow between two points is a transformation of one value into the other.
Thus, a line-count program is an arrow from string to integer.

If one inspects the path of the arrow connecting input to output, one finds more 
dots connected by more arrows. 
That is because it is possible to create one arrow between two points by 
placing two arrows between three points.
The line-count program might be a combination of two arrows: string to array and
array to integer.
When there is an arrow from string to array and an arrow from array to integer,
then it is said that there is an arrow from string to integer.

Laws dictate the arrows that exist between every pair of points.
To connect two points, the functional programmer follows a law.
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
But the second group tried to abstract the details of the problem to the laws 
first and then work out the numbers.
Perhaps students in the second group still used the prescribed techniques but 
they did so knowing why that techniques had been prescribed.

The decision tree was a limited form of understanding. 
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
But I am working to change this because I remember the usefulness of the 
seemingly unuseful laws from eighth-grade algebra.

The promise of functional programming is that knowing the laws will make me a 
more capable programmer just as it made me a more capable math student.
In this sense, the best functional programming language is the language of those
laws.
Whether or not I learn the laws through the use of a programming language, 
I must learn the them to learn functional programming.
The argument remains that the theory can be learned later, after learning the 
techniques.
I suppose this is true.
But I wonder how an Elm programmer is ever made aware of the theory.
How can the language make me aware when it avoids the subject?
It is not necessarily the responsibility of the language to convey the theory to
the programmer.
Nonetheless, I am best served as a student of functional programming by a 
language that exposes me to these concepts.
