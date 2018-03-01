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

A language is called "functional" when the language lends itself to the 
expression of a certain kind of thought.
You have done functional programming when you have engaged in that kind of 
thinking.
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
And if one inspects the path of the arrow connecting input to output, one finds 
more dots connected by more arrows.
Functional programming is connecting dots with arrows while following some 
laws about which arrows connect which dots.

<!--
This way of thinking is borrowed from math.
It is not borrowed from math because it is esoteric and it is not meant to be 
"self-defeating".
The result of a mathematical expression, its meaning, can be universally 
understood.
Functional programming tries to find in math a language for programming that is 
reliable in this way.
Functional programming tries to find in math a language for expressing the 
logic of software that is universally understood.
I can't say whether functional programming succeeds in this attempt.
My point is that the theoretical language is an essential aspect of 
functional programming to the degree that this language is used to talk about
this way of thinking.
-->

On paper, I think I resemble Elm's target audience.
I do not have a math background and I haven't understood math since I finished 
eighth-grade Algebra I.
What I remember about eighth-grade algebra is that I learned some laws and then 
I applied those laws to math problems.
Most laws came with calculation techniques, something like dividing a number on 
the right side by a number on the left side.

Students used the calculation techniques in one of two ways.
Some students became skilled at memorizing which techniques went with which 
kinds of problems.
This approach is similar to the Elm method of functional programming; focus on 
how to get a desired result and not why.
As long as one knew the technique and knew when to use the technique, then 
one didn't necessarily need to know the law.
This worked like a decision tree: if the details of the problem are like x, then 
use y technique. 
In that approach, the laws weren't essential information.

The second approach was to try to abstract the details of the problem to the 
algebraic laws and then work out the numbers.
In this approach, one might still use the calculation technique.
The difference was how one chose which calculation technique to use.
In the first approach, one uses the calculation technique because one remembers
that this technique has worked in the past for a similar kind of problem.
In the second approach, one works to apply the law to the problem and the 
calculation technique, incidentally, is the way to do this.
The difference between the two approaches is that the second approach enables
you to make an educated guess about what to do when you encounter an 
unfamiliar problem.

Other students 

What I remember about eighth grade algebra was that I was taught some laws 
and then I was asked to apply those laws to some problems.

<!--
I haven't felt like I understood math since I finished eighth-grade algebra.
What I remember about eighth-grade algebra is that I learned some laws and then 
I applied those laws to math problems.
There was generally two ways of approaching the math problems.

The first approach was prescriptive.
There was always a suggested technique for applying the law to the problem.
As long as one knew the technique and knew when to use the technique, then 
one didn't necessarily need to know the law.
Some students became skilled at memorizing which techniques went with which 
kinds of problems.
This worked like a decision tree: if the details of the problem are like x, then 
use y technique. 
In that approach, the laws weren't essential information unless the test 
required the student to name the law leveraged by the technique.

I disliked the decision tree style of doing algebra because I was only pleased 
to have the correct answer if I understood why it was correct.
The decision tree was a very limited form of understanding. 
It only enabled the individual to solve familiar problems.
Unfamiliar problems required an extension of the decision tree, even 
if the solution simply used a new combination of familiar laws.
I was a lazy math student and I suspected that the decision tree was a trap.
Maintaining the tree couldn't end until all kinds of problems had been
encountered and I suspected this meant a lot of work.

The second approach, my approach, was to focus more on the laws than the 
numbers.
I relish learning because I feel empowered by understanding.
It was the algebraic laws, not the decision tree, that empowered me.
New combinations of familiar laws were less work to learn because they required
a smaller mental shift.
And sometimes I could make that shift on the fly, without having to study.
This reduced time spent on math outside of class and saved me more than once on 
a test.
I wasn't a gifted algebra student but I really liked knowing those laws and 
-->
Two approaches emerged among my classmates.
The first approach was to memorize which technique went with which kind of 
problem.
I liken this to the Elm method of functional programming - focus on the concrete
techniques for problem solving in a domain space.
This was an decision-tree algebra.

The second approach was to try to abstract the details of the problem to the 
algebraic laws and then work out the numbers.
In this approach, one might still use the calculation technique.
The difference was how one chose which calculation technique to use.
In the first approach, one uses the calculation technique because one remembers
that this technique has worked in the past for a similar kind of problem.
In the second approach, one works to apply the law to the problem and the 
calculation technique, incidentally, is the way to do this.
The difference between the two approaches is that the second approach enables
you to make an educated guess about what to do when you encounter an 
unfamiliar problem.

Knowing the laws of the system enables one to do something new with that system.
I find that to be the great promise of functional programming.
I want to know the theory, the laws governing the arrows between input and
ouput, so that I can be empowered to do something new.

The argument remains that the theory doesn't have to come first.
That is true.
But I wonder how an Elm programmer is made aware of the theory.
The language will not make her aware.
Elm conceals the theory.
Elm's creator describes the process of developing an understanding of monads.
He says that he first felt like he understood them in six months and that he 
developed a deep understanding of monads after about a year and a half of using
them.
He seems to imply that this is an unreasonably long amount of time.
It is hard for me to relate to this.
Many things which I find very useful and which seem simple in retrospect, took
me much longer than a year and a half to absorb.
For example, every day use of the English language is something I usually do 
without thinking today but it took many years to achieve that.
I am learning German now and I am painfully slow.
<!--
But I would never think that because this process is slow a, that
the information should be avoided.
-->
I am generally baffled if someone says something in German to me.
But that does not mean that those who are speaking German are "self-defeating" 
and should avoid doing so.
It means that I should learn German.
The same is true for the language of functional programming.
If we are to be functional programmers, we should not shrink back from the 
discomfort of our initial ignorance.
We should have greater confidence in our ability to understand and should be 
encouraged by our programming language to seek this understanding.
And we should do so not to enter pissing contests but to be empowered by 
what we can understand.

Elm, by concealing the theory from us, exhibits what my Dad calls "the soft
bigotry of low expectations".
That is, the design implies a doubt about the user's ability to understand 
what is really going on.
Elm promises to explain this to you later and then never does.
Those Elm programmers who seem to wait for solutions to be handed down by the 
language's creator are stuck with decision tree algebra.
They are standing on a path that they cannot follow further because they do not
know that each knew direction follows that path.

# Draft 1

Elm is a functional programming language that largely avoids the vocabulary of
functional programming.
Debates about contramap versus contravariant bifunctor seldom occur in the world 
of Elm.
And though Elm's `Maybe` might be one instance of a "monoid in the category of 
endofunctors", there is no concept of a monad in Elm.
Instead, Elm focuses programmers on concrete patterns for problem solving in the 
domain of user interfaces.
It is possible for an Elm programmer to write Elm programs with little awareness
of the theory implied by their work.

Perhaps the vocabulary of functional programming is absent from the world of Elm
because Elm programmers do not depend on this 
The vocabulary of functional programming is largely absent from the world of 
Elm perhaps because Elm programmers do not need this vocabulary to be 
productive.
Evan Czaplicki, Elm's creator, has argued that this vocabulary is unsuitable for 
an introduction to the subject and has suggested that the underlying theory of
functional programming should be introduced after a programmer has become 
proficient with a functional programming language.


should be introduced after a programmer has become proficient applying those
concepts.

right time to 
introduce theo.

Elm inherits these concepts
Elm inherits these concepts without explicitly passing the lineage to language
users.


The language's design inherits these concepts but does not pass them through to 
language users.

Elm is focused on concrete applications of functional programming theory to 
the domain of user interfaces.

The vocabulary of functional programming is largely absent from the world of Elm 
simply because it is not needed.



Instead, Elm teaches concrete applications of functional programming theory to 
the domain of user interfaces.
Elm programmers can write Elm programs without being aware of the theory 
implied by their work.

The theory 
Theoretical discussions in t
Theoretical discussions are largely practical (e.g. why data structure to use)

Elm avoids the vocabulary of functional programming to the degree that this 
vocabulary is theoretical 


It seems to me that this vocabulary is largely absent from Elm because 

for thinking about theory

for talking about 
The vocabulary of functional programming is largely absent from Elm because that
vocabulary is used to talk about theory explicitly and Elm programmers mostly
do not.



The vocabulary of functional programming is largely absent from Elm
because that vocabulary is only necessary when the theory is explicit.


The vocabulary of fun
The vocabulary of functional programming is heavily theoretical 
absent from the Elm language
because that vocabulary is mostly ot n.

The argument is that the theory is an unnecessary impediment to using the 
language.

Elm programmers can write Elm programs that 
Elm programmers can become proficient applying the theory (by writing Elm 
programs) without being aware of the theory itself.

with a significant subset of the theory 
develop an intuition 
for how the 
by applying the theory to the domain
of user interfaces.

by enabling programmers to apply the

to build user interfaces by 
introduces functional programming by enabling programmers to 
build user interfaces with a language that concretely applies the theory to the 
domain.
apply the theory to the domain of user interface programming.
concrete applications of 
the theory to the domain of user interfaces.
demonstrating productive k
applications of the theory to the domain of user interfaces.

It is possible to be a productive functional programmer without a significant 

The language is designed to enable a practice of functional programming without
a deep awareness of functional programming theory.

The design of the language is meant to enable a productive practice of 
functional programming without a deep awareness of the theory.


remove the theoretical dependency from 
the practice of 
functional programming 
Elm emphasizes the practice of functional programming over the theory of

Elm is designed to enable functional programming without 

Elm is designed to make monads and other concepts useable without depending on 
their theory.


Elm is designed to de-emphasize the theory of functional programming.

Elm removes the dependency on the theory of functional programming. 
The 
theoretical concepts like monad.
The language is meant to teach functional programming by making programmers 
productive with a functional language.


make programmers productive with a  aims to make programmers productive in a functional language without 
depending on theoretical concepts like monad.


>...design the language such that as someone gets started and gets 
>productive, slowly they realize these concepts in a way that builds upon each 
>other...

The Elm pedagogy aims to teach functional 
Elm teaches functional programming by making a student productive with a 
functional programming language.

The Elm pedagogy is to teach functional programming by making a student 
productive with a functional programming language.

someone functional programming by teaching that 
person to be productive with a functional programming language.
The assumption is that the student has learned functional programming when they
have become productive with the language.

There are a couple of assumptions bundled into this pedagogy.

The first assumption is a notion of beginners as people who must be shielded
from information that makes them feel uncomfortable.

The second assumption is that, when you have taught someone to be productive
with a functional programming language, that they have understood something 
about functional programming itself.

If, in your attempt to make some information easily understood, you have 
truncated that information, 

The truest "functional programming language" is not a programming language - 
it is a conceptual language.
You have done functional programming when you have engaged in a kind of 
thinking.
And to the degree that Elm or Haskell or Clojure forces you into this way of 
thinking, then proficiency with the language can amount to an understanding of
the subject. 
But I think that the act of functional programming is in the thinking.
Programming languages are called functional when they lend themselves to 
expressing those thoughts.
There is one functional programming language, the language of the theory of 
functional programming.

I don't clearly know what makes a programming language "functional".
Quite a bit of functional programming can be done in any language featuring 
first class functions but not all of those languages are commonly called 
functional.
Perhaps a functional programming language is one that lends itself to 
expressing a way of thinking.
This way of thinking is also expressed by the theory of functional programming.
It is a way of thinking that was borrowed from math not because math dependably
intimidates the unitiated but because the correctness of mathematical ideas is
knowable and the result of their application is reliable.
because math is a lossless medium of thought 
compression.
The correctness of most mathematical ideas is knowable and the results are 
reliable

language of math is rigorous and the 
outcomes are reliable.


because math is the most
reliable form of human communication.

math is the form in
which human thought is transferred from one mind to another most clearly and 
most reliably.

clearest
and most reliablel
mathemetical
thought is 

clearest, most
reliable clear to read and reliable to run.
math is not 
subjective

are 
provable 
tend 
to be objectively sound.

not to intimidate the 
unitiated but to 
to intimidate the 
uninitiated or to engage in mutual masturbation of the mind, but because 
concepts from math tend to be objectively sound.
And to the degree that Elm or Haskell or Clojure forces me into this way of 
thinking, then proficiency with the language can amount to an understanding of
the subject.
But I think that the act of functional programming is the thinking itself. 
I have done functional programming when I have engaged in this way of thinking,
not when I have used a functional programming language productively.


It seems to me that a functional programming language is one that lends itself
to expressing a way of thinking.
The theoretical vocabulary of functional programming is also an attempt to 
express this way of thinking.
It is a way of thinking that is borrowed from math 

But it seems to me that functional programming languages lend themselves to 
expressing a way of thinking.
The vocabulary of functional programming, words like "monad", "functor, and 
"curry" are also meant to express that way of thinking.
It is a way of thinking that comes from math 


When I look for the unifying factor among the several functional languages I 
know of, 
I think that there is only one "functional" language.
It is a conceptual language, not a programming.
I have done functional programming when I have engaged in a kind of thinking.
And to the degree that Elm or Haskell or Clojure forces me into this way of 
thinking, then proficiency with the language can amount to an understanding of
the subject.
But I think that the act of functional programing is the thinking itself, not 
the use of a "functional programming language".

It seems to me that there is only one "functional" language and it is not a 
programming language.
The language of functional programming is a conceptual language.


Functional programming is an attempt to think about programming in a way that 
transcends the subjectivity of any one programming language.

Learning about the features of a so-called functional language does 
Learning about the features 

I could do quite a bit
It seems to me that I could do a lot of functional programming with  


Functional programming is an attempt to share a way of thinking about 
programming.
The language is not tied to 
Functional programming is an attempt to share a language of programming that is
not a requirement to use the same programming language.

not assume 
without 
expecting all programmers to use the same programming language.

programming lanaguage

find a shared language.
The language is borrowed from math.


The vocabulary of functional programming is the language of this thought - it is
this language that is the functional programming language, and the programming
languages that are called functional are called functional because they are
sympathetic to this way of thinking.



1. "How close is the Redux connect() function to a Bifunctor (see Fantasy Land for 
details) ? Honest question. Could it have been designed with bimap somehow?" 
&mdash; [@andrestaltz](https://twitter.com/andrestaltz/status/956241231541161984)

"Seems like a contramap to me. So a contravariant bifunctor abstracting the 
connect function itself as a builder"
&mdash; [@drboolean](https://twitter.com/drboolean/status/956291210221518848)
1."All told, a monad in X is just a monoid in the category of endofunctors of X, 
with product × replaced by composition of endofunctors and unit set by the 
identity endofunctor."  Saunders Mac Lane in _Categories for the Working 
Mathematician_ via [StackOverflow](https://stackoverflow.com/questions/3870088/a-monad-is-just-a-monoid-in-the-category-of-endofunctors-whats-the-proble%E2%85%BF)


Exchanges like 
Elm programmers seldom 

The design of a programming language expresses the opinions of its designer.
One opinion expressed by the Elm language is that the vocabulary of functional
programming is unsuitable for an introduction to the subject.
Exchanges like this seldom occur 

> "Seems like a contramap to me. So a contravariant bifunctor abstracting the 
connect function itself as a builder"

&mdash;@drboolean




The Elm language expresses the opinion that the language of functional 
programming is unsuitable for an introduction to the subject.

<!--
## I.

I haven't felt like I understood math since I finished eighth-grade algebra.
What I remember about eighth-grade algebra is that I learned some laws and then 
I applied those laws to math problems.
There was generally two ways of approaching the math problems.

The first approach was prescriptive.
There was always a suggested technique for applying the law to the problem.
As long as one knew the technique and knew when to use the technique, then 
one didn't necessarily need to know the law.
Some students became skilled at memorizing which techniques went with which 
kinds of problems.
This worked like a decision tree: if the details of the problem are like x, then 
use y technique. 
In that approach, the laws weren't essential information unless the test 
required the student to name the law leveraged by the technique.

I disliked the decision tree style of doing algebra because I was only pleased 
to have the correct answer if I understood why it was correct.
The decision tree was a very limited form of understanding. 
It only enabled the individual to solve familiar problems.
Unfamiliar problems required an extension of the decision tree, even 
if the solution simply used a new combination of familiar laws.
I was a lazy math student and I suspected that the decision tree was a trap.
Maintaining the tree couldn't end until all kinds of problems had been
encountered and I suspected this meant a lot of work.

The second approach, my approach, was to focus more on the laws than the 
numbers.
I relish learning because I feel empowered by understanding.
It was the algebraic laws, not the decision tree, that empowered me.
New combinations of familiar laws were less work to learn because they required
a smaller mental shift.
And sometimes I could make that shift on the fly, without having to study.
This reduced time spent on math outside of class and saved me more than once on 
a test.
I wasn't a gifted algebra student but I really liked knowing those laws and 
putting them to work.
It was not the first time but certainly one time that I knew what Richard 
Feynman called "the pleasure of finding things out".

I do not clearly remember my life with math after algebra.
Sometime after eighth grade, conceptual thought receded from the foreground of 
math class.
The game became mostly about plugging the right numbers into the right formula 
and writing down the result.
I resented the students who were good at this game; it seemed unjust to reward
them for blindly following instructions.
I wanted to learn things in a way that enabled me to make new connections, to 
make mental shifts on the fly as I had done in eighth grade algebra.
Instead, I was set to memorizing a procedure to produce some numbers using a 
trigonometric function.
I was urged by my teachers to simply accept the pieces as they were handed to me
and the class moved on while I tried to divine the logical system that related
these pieces to an unseen whole.
In this way, I learned very little about math after the eighth grade.

My math grades steadily declined and my math education concluded relatively 
early, after the third year of high school.
I barely passed the last class and turned in at least one test that was covered 
with drawings instead of answers.
I was headed to art school and assumed that drawing, not math, was my future.
Now I'm thirty-one and it's been awhile since I've done any drawing.
But sometimes I watch math videos on the internet.
Programming is the reason for both of those unexpected outcomes.
And functional programming in particular is the reason I'm excited about math.
-->


<!--
"How close is the Redux connect() function to a Bifunctor (see Fantasy Land for 
details) ? Honest question. Could it have been designed with bimap somehow?"
https://twitter.com/andrestaltz/status/956241231541161984
@andrestaltz

"Seems like a contramap to me. So a contravariant bifunctor abstracting the 
connect function itself as a builder"
https://twitter.com/drboolean/status/956291210221518848
@drboolean

"Go is, like every language, a political vehicle. It embodies a particular set 
of beliefs about how software should be written and organized."
https://grimoire.ca/dev/go


"On day one, you get smacked with a lot of details, a lot of intense sounding 
stuff."
Evan Czaplicki
http://www.elmbark.com/2016/03/16/mainstream-elm-user-focused-design

"As people start seeing this in different libraries, maybe they’ll be 
interested in the general pattern. The point is you don’t have to understand 
the general pattern to get up to speed and use this kind of thing."
http://www.elmbark.com/2016/03/16/mainstream-elm-user-focused-design

"When you want to tell something, there’s a general pattern here. What do you 
call it? Is it a little bit like we say…

You call it a monad, of course. Obviously. "
http://www.elmbark.com/2016/03/16/mainstream-elm-user-focused-design

Having failed at math in highschool is a primary reason I avoided programming
until I was twenty-seven.


I couldn't understand how anyone could feel happy memorizing a procedure to 
produce some numbers with a trigonometric function.

I wanted to understand the conceptual system 
I wanted the trigonometric functions to 

I wanted to understand the trigonometric functions as ideas before I learned
how to use them.
Instead, I was supposed to memorize 

Meanwhile, the class moved on while I tried to make the trigonometric functions
make sense as a system of ideas.
Instead, I was supposed to memorize how to use them to produce some numbers.
Math class 
Simply memorizing their utilities in the context of a calculation 


I do remember resenting math class because it made me feel stupid and I 
remember resenting the students who succeeded in math.
I suspected that these were the same stud

Choosing something because I had been told it was the right choice did not 
satisfy me.
I was a successful algebra student because I felt like (and must have, to some
degree) I understood the laws.
I didn't have any deep insight into these laws but they seemed natural to me.

I solved basic algebra problems by matching 
and I liked recognizing how a math problem followed 
those laws.
Solving the problem was a demonstration of my understanding and proving that 
I understood the principle satisfied me.

I remember feeling stupid and I remember resenting students who got good grades.
These were the same students who had learned algebra by memorizing which 
calculation techniques go with which kinds of math problems.
I thought they were mindless because they could not explain what a "cosine" or
a "coefficient" meant, just when and how to use them.
It seemed unjust to me that they were rewarded for blindly following 
instructions.

Math came to signify this mindlessness.

I needed to internalize the principle of those instructions before I could or 
would follow those instructions.
But the game was plugging the right numbers into the right formula and 
writing down the result.


Programming 
I avoided programming until I was twenty-seven because I assumed that 
programmers must be good at math.
When I fin



Math made me feel stupid.

I learn best when I use some information to take an action.
The action is informed by how I understand the information and the result of the
action either confirms or denies the correctness of my understanding.
If my understanding is confirmed, I add to the information and test again.
If my understanding is denied, I adjust my understanding and try again.
In this way, I feel my way toward comprehension.

implies a hypothesis 

can take some information and use that information to 
I think I learn through experience.
I 

I think I learn through experience, through using a piece of information 
I figured that I would graduate, go to art school, and use very little math 
after that.

This was frustrating.
In the world of programming, when it can sometimes feel exhausting to be learning
so many new things
-->
