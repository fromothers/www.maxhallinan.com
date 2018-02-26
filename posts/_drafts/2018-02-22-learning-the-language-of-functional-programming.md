---
layout: post
title: "Learning the Language of Functional Programming"
tags: [elm, programming]
---

Elm is a functional programming language that largely avoids the vocabulary of
functional programming.
Debates about contramap versus contravariant bifunctor seldom occur in the Elm 
community.
And though Elm's `Maybe` might be one instance of a "monoid in the category of 
endofunctors", there is no concept of a monad in Elm.
Evan Czaplicki, Elm's creator, has argued that this vocabulary is unsuitable for 
an introduction to the subject.
Instead, Elm teaches concrete applications of functional programming theory to 
the domain of user interfaces.
Applications of the theory are taught without teaching the theory itself and
Elm programmers can write Elm programs without being aware of the theory 
implied by their work.
The vocabulary of functional programming is largely absent from Elm simply 
because it is not needed.
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
Programming languages are called functional when lend themselves to expressing 
these thoughts.
more than 
the language use.
The vocabulary of functional programming is the language of this thought - it is
this language that is the functional programming language, and the programming
languages that are called functional are called functional because they are
sympathetic to this way of thinking.


in itself, not
in the language.


This begs the question "what is a functional programming la


To teach someone functional programming is to teach someone to be productive 
with a functional programming language.


Functional programming is taught 
The Elm pedagogy of functional programming is 

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

The design of a programming language expresses the opinions of its designer.


an introduction to functional
programming should not use the language of 
the language of functional 
programming is 

language of functional 
programming 
One opinion expressed by the Elm language is that the language of functional 
programming is not beginner friendly.


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
