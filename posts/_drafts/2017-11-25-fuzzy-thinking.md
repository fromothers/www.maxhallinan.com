---
layout: post
title: "Fuzzy Thinking: Property Testing and Formal Grammar"
---

There are two rabbit holes here: property testing and formal grammar. 
I traveled down both simultaneously and found that they converged.
This article retraces those paths.

## Hunting for blindspots

> But there are innumerable ways of dividing and selecting for 
> attention the facts and events, the data, required for any prediction or 
> decision, and thus when the moment comes for a choice there is always the 
> rankling doubt that important data may have been overlooked.
>
> &mdash; Alan Watts, _This Is It and Other Essays on Zen and Spiritual Experience_

Let's say we have a function `hexToRgb` that converts a hex color string to a 
RGB value. 
The implementation of `hexToRgb` is unimportant.
We're only interested in the type signature.
`hexToRgb` takes a string (the hex color value) and returns a `Result` with
an error string or a RGB representation:

```
hexToRgb : String -> Result String (Int, Int, Int)
```

Now we want to test `hexToRgb`.
The first test we write is a unit test that asserts `hexToRgb "#ffffff"` 
returns `Ok (255, 255, 255)`.
This test focuses on the correctness of the conversion formula.
If `hexToRgb` converts `"#ffffff"` to `Ok (0, 0, 0)`, then it's no use at all.
So this is a reasonable first test to write.
But once this test passes, we're not done testing.

There are a handful of things that this test doesn't tell us.
For example, how do we know that `hexToRgb` can really handle _any_ valid hex 
color strings when we've only tested one?
We might assume that `hexToRgb` will work for all valid strings if
it works for `"#ffffff"`.
But maybe there's an edge case we aren't aware of.
Or maybe `hexToRgb` returns an `Err` for any hex color that isn't `"#ffffff"`.
We won't know until we write more tests.

We could simply generate all the valid hex color strings and then write a test
that calls `hexToRgb` on all of them. 
But there are a lot of hex colors. 
In fact, there are [16,781,312](https://en.wikipedia.org/wiki/Web_colors) 
of them.
So we decide to take this idea and scale it down. 
Instead of generating millions of hex colors, we generate 75 or a 100. 
And we generate these hex colors randomly each time the test runs. 

It doesn't matter that the hex colors are different each time the test runs
because we're not testing the conversion itself.
We just want to test that nothing unexpected happens when we call `hexToRgb`
with a valid hex color.
The test will simply assert that `hexToRgb` returns an `Ok _` for any valid
hex string.


## Generating random inputs

This approach to testing is called property testing or "fuzz" testing. 
Fuzz testing requires us to think more generally about our inputs.
Instead of writing tests for specific values like `"#ffffff"`, we write tests
for _kinds_ of values, in this case hex color strings.

We're going to use the `Fuzz` module from the `elm-community/elm-test` package
to generate these random inputs.
Fuzz tests written with `elm-community/elm-test` use a `Fuzzer` to generate
random values of a certain type.
For example `Fuzz.string` is a `Fuzzer String` that generates a random string
of any length.
Likewise, `Fuzz.int` is a `Fuzzer Int` that generates a random integer.
If `hexToRgb` took any string or any integer, these Fuzzers would be useful.
Unfortunately, not every string or every integer is a valid hex color.
And the `Fuzz` module does not expose a hex color string Fuzzer.
We have to define our own.

Defining our own Fuzzer doesn't mean implementing the `Fuzzer` type from 
scratch. 
In addition to basic Fuzzers like `Fuzz.string` and `Fuzz.int`, the `Fuzz` 
module exposes helper functions that can be used to combine small, simple Fuzzers
into large, complex Fuzzers.
Our job is to break the concept of a "valid hex color" into smaller parts that 
can be represented by the tools we have.
Then, we'll use those tools again to connect these parts.
The result will be a Fuzzer that generates a random valid hex color string.


## Thinking in patterns 

>Human thinking can skip over a great deal, leap over small misunderstandings, 
>can contain ifs and buts in untroubled corners of the mind. But the machine 
>has no corners.
>
>&mdash; Ellen Ullman, _Close to the Machine: Technophilia and Its Discontents_

To find the elements of a hex color, let's think of a hex color string as a 
pattern of characters:
The first character of the string is always `#`.
Every character after the first must be a valid hexadecimal digit.
Hexadecimal digits are the integers `0` through `9` and the characters `A` 
through `F`.
Lowercase and uppercase alphabetic characters are both valid.
The hexadecimal string for a hex color is always three digits or six digits long.

This pattern doesn't sound too complicated but our description of the pattern is
ambiguous.
For example, we forgot to mention that a hex number does not include any 
whitespace. 
Maybe those who are familiar with hex color strings would "leap over" this 
"small misunderstanding" but we can't be certain that everyone would.

So we add another item to the list that says "Hex color strings do not contain 
whitespace".
But now we have to define whitespace.
Is whitespace just a space character? Or spaces and tabs?
What about linebreaks?
In this way, the requirements become more verbose and 
misintepretation becomes more likely.
Exact meanings are hard to express with natural language.
We find ourselves reaching for a language with fewer possible meanings and 
fewer words required to say what we mean.
This is when formal grammar becomes useful.


## What is formal grammar

It might feel like we are drifting from the original task of generating random
hex colors.
Do we really need a more exact specification? 
We could start building our hex color Fuzzer and address latent ambiguities as 
they arise.
While this is true, writing a formal grammar for hex color strings is
a worthwhile exercise.
In addition to exposing ambiguities, our hex color grammar will show us how to
structure our Fuzzers.

A formal grammar is a notation that uses patterns of symbols to describe a set 
of valid strings.
The patterns of symbols are the "grammar of" whatever you are describing.
There are two types of symbols in formal grammar: terminal and nonterminal.
The names terminal and nonterminal imply action or movement.
A terminus is where something stops or ends.
In this case, the action or movement is replacement.
Given a nonterminal symbol, we want to replace it with a terminal symbol.
A string is valid if the nonterminal symbols can be replaced with terminal 
symbols in a way which produces that string.

Formal grammar is a theoretical subject but we can learn what we need to know
by looking at an example.
Let's say that we have four strings: `"aa"`, `"AA"`, `"aA"` and `"Aa"`.
These strings form our language.
Only these four strings are valid in this language.
Here's how we can describe that language with a 
[context-free grammar](https://en.wikipedia.org/wiki/Context-free_grammar):

```
Start = Char, Char

Char = "A" | "a"
```

Let's walk through the process of testing whether `"aA"` is a valid sentence
according to our grammar.
We take the first character in `"aA"` which is `"a"`.
Then we look at the right side of the `Start` symbol, moving left to right.
First we encounter the nonterminal symbol `Char`.
In order to test whether `"a"` matches `Char`, we have to replace `Char` with
a terminal symbol.
To do this, we go down to the definition of `Char`. 
On the right side of `Char`, we first find `"A"`. 
`"A"` does not match `"a"`. 
But `"A"` is not our only option. 
`|` is the logical OR.
So `Char` can be replaced with `"A"` or `"a"`.
`"a"` matches `Char`.
So far, so good.

Now we need to test the second character in our string: `"A"`.
We return to `Start` and move right, finding a second nonterminal symbol `Char`.
In the same way that we tested `"a"`, we find that `"A"` matches `Char`.
And now we are out of characters to test and nonterminal symbols to replace.
Our string ends where are pattern ends.
The pattern of characters in our string match the pattern of symbols in our
grammar.
`"aA"` is a valid sentence in our language.


## A formal grammar for hex colors

Now let's write a context-free grammar for a hex color string.
We'll start with our atomic elements, the terminal symbols, and work up to 
the `Start` symbol.

All hex colors are hexadecimal numbers.
To write a hex color grammar, we must first write a grammar for hexadecimal 
numbers.
A hexadecimal number is base 16 which means that there are sixteen digits, 
instead of the usual 10 digits.
These digits are represented by the integers `0` through `9` and the letters `A` 
through `F`.
Let's start by creating a nonterminal symbol called `Num`.

```
Num =
  = "0"
  | "1" 
  | "2" 
  | "3"
  | "4"
  | "5"
  | "6"
  | "7"
  | "8"
  | "9"
```

The alphabetic digits are slightly more complicated because any letter can be 
lowercase or uppercase. 
We describe this by creating a nonterminal symbol for each letter and then 
joining these in an `Alpha` symbol. 

```
A = "A" | "a"

B = "B" | "b"

C = "C" | "c"

D = "D" | "d"

E = "E" | "e"

F = "F" | "f"

Alpha
  = A
  | B
  | C
  | D
  | E
  | F
```

In a similar fashion, we join `Num` and `Alpha` in a `HexDigit` symbol. 
This is our first hex color building block.

```
Hex1
 = Alpha
 | Num
```

Another atomic element of a hex color string is the `#` symbol.
Every hex color (in our grammar) starts with this character.
This is our second hex color building block.

```
Hash = "#"
```

Now that we've described the atomic elements of a hex color string, we can
start to describe the string itself.
Hex colors come in three-digit and a six-digit formats.
We'll worry about adding the hash later. 
For now, we'll focus on describing these three and six digit patterns.

```
Hex3 = Hex1, Hex1, Hex1

Hex6 = Hex3, Hex3
```

To describe the three-digit format, we simply repeat the `Hex1` symbol three 
times.
And to describe the six-digit format, we simply repeat the `Hex3` symbol 
two times.
Now we have all the building blocks we need to define the `Start` symbol.

```
Start 
  = Hash, Hex3 
  | Hash, Hex6
```

All together, here is the grammar:

```
Start 
  = Hash, Digit3
  | Hash, Digit6

Hash = "#"

Hex6 = Hex3, Hex3

Hex3 = Hex1, Hex1, Hex1

Hex1 = Num | Alpha

Num  
  = "1" 
  | "2" 
  | "3"
  | "4"
  | "5"
  | "6"
  | "7"
  | "8"
  | "9"

Alpha
  = A
  | B
  | C
  | D
  | E
  | F

A = "A" | "a"

B = "B" | "b"

C = "C" | "c"

D = "D" | "d"

E = "E" | "e"

F = "F" | "f"
```


## From formal grammar to Fuzzer

You might have noticed that our formal grammar made liberal use of two powerful
patterns: recursion and composition.
Nonterminal symbols are resolved to terminal symbols recursively.
Smaller patterns are composed to create larger patterns.
We can use the same approach to create a hex color `Fuzzer`.

Just as we did with our hex color grammar, let's start with the smallest
pieces: letters and numbers.
`Fuzz.string` and `Fuzz.int` aren't much help because they generate _any_ random
`String` or `Int`, including letters and numbers that aren't valid hexadecimal
digits.

Instead we can use `Fuzz.constant` to create a `Fuzzer` for each of these digits.

For example, a `Fuzzer` that always generates a `"1"` is

```
one : Fuzzer String
one =
  Fuzz.constant "1"
```

Then we can use `Fuzz.oneOf` to combine each of our letter and number fuzzers
to create a `Fuzzer` that will generate one of these strings randomly.

```
{-
  From our hex color grammar: `Digit1 = Num | Alpha`.
-}

digit1 : Fuzzer String
digit1 =
  Fuzz.oneOf
    [ alpha
    , num
    ]

alpha : Fuzzer String
alpha =
    Fuzz.oneOf
        [ Fuzz.constant "a"
        , Fuzz.constant "b"
        , Fuzz.constant "c"
        , Fuzz.constant "d"
        , Fuzz.constant "e"
        , Fuzz.constant "f"
        , Fuzz.constant "A"
        , Fuzz.constant "B"
        , Fuzz.constant "C"
        , Fuzz.constant "D"
        , Fuzz.constant "E"
        , Fuzz.constant "F"
      ]

num : Fuzzer String
num =
    Fuzz.oneOf
        [ Fuzz.constant "0"
        , Fuzz.constant "1"
        , Fuzz.constant "1"
        , Fuzz.constant "2"
        , Fuzz.constant "3"
        , Fuzz.constant "4"
        , Fuzz.constant "5"
        , Fuzz.constant "6"
        , Fuzz.constant "7"
        , Fuzz.constant "8"
        , Fuzz.constant "9"
        ]
```

Then we can do the same thing with the hash character.

```
hash : Fuzzer String
hash =
    Fuzz.constant "#"
```

Once again, we have our basic building blocks and we want to start combining
them into more complex patterns. 
To create `Fuzzer`s that generate three and six-digit hexadecimal numbers,
we use `Fuzzer.map` and string concatenation.
For a 3-digit hex number, we'll map over three fuzzers and concatenate the
hex digit generated by each `digit1` fuzzer.

```
digit3 : Fuzzer String
digit3 =
  Fuzz.map3 (\a b c -> a ++ b ++ c) digit1 digit1 digit1
```

Let's take a moment to extract some helper functions.


```
repeat2 : Fuzzer String -> Fuzzer String
repeat2 fuzzer =
    Fuzz.map2 (++) fuzzer fuzzer

repeat3 : Fuzzer String -> Fuzzer String
repeat3 fuzzer =
    Fuzz.map2 (++) fuzzer <| repeat2 fuzzer
```

Now we can use these abstractions to simplify the `digit3` fuzzer and create 
a `digit6` fuzzer.

```
digit3 : Fuzzer String
digit3 =
    repeat3 digit1

digit6 : Fuzzer String
digit6 =
    repeat2 digit3
```

These fuzzer definitions look quite similar to the `Digit3` and `Digit6` nonterminal
symbols from our hex color grammar.

```
Digit3 = Digit1, Digit1, Digit1

Digit6 = Digit3, Digit3`
```

What's left is combining these `digit3` and `digit6` to create a `hex` fuzzer. 
This fuzzer will only generate a three-digit or a six-digit hexadecimal number,
the only kinds of hexadecimal numbers that we consider to be valid.


```
hex : Fuzzer String
hex =
  Fuzz.oneOf
    [ hex3
    , hex6
    ]
```

Finally we add the hash to the front of this unknown, random hexadecimal number.
Now we have a fuzzer that generates random, valid hexadecimal color strings.

```
hexColor : Fuzzer String
hexColor =
      Fuzz.map2 (++) hash hex 
```


## Formal grammar is Fuzzy thinking

Formal grammar provides a useful mental model for structuring fuzzers.
Each fuzzer is equivalent to a nonterminal symbol.
The easiest fuzzers are the most general, such as `Fuzz.string` and `Fuzz.int`.
More specific values require more complex fuzzers.
To build up complexity, create smaller fuzzers and combine them.
Thinking in terms of nonterminal and terminal symbols helps to identity the overall
pattern and each of the smaller patterns that the large pattern is composed of.
By starting with the simplest patterns first and combining them, it becomes 
relatively easy to create fuzzers that generate random values within 
complex constraints.
