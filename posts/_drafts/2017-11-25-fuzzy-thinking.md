---
layout: post
title: Fuzzy thinking&#58; formal grammar and property testing
---

I was recently exploring two things that I thought were unrelated: formal
grammars and property (or "fuzz") testing.
At some point, I started to feel like my newfound understanding of formal grammar 
was helping me to write fuzz testers.
I want to describe that connection here because it seems to me that knowing
a little about both subjects made them each a little easier to understand 
in isolation.
(I'm also writing this because it's fun to play around with the possible connections 
between seemingly unrelated things, whether or not the connection really exists.)


## The problem

Let's say we have a function `hexToRgb` that converts a hex color value to an
rgb value. 
We don't need to know about the implementation of `hexToRgb`.
We're only interested in the type signature:

```elm
hexToRgb : String -> Result String (Int, Int, Int)
```

`hexToRgb` takes a string (the hex color value) and returns a `Result` with
a string describing an error or a tuple representing an RGB value.

We're not worried about implementing this function but we are worried
about testing it.
We've taken a solid first step by testing that `hexToRgb` converts
`"#ffffff"` to `Ok (255, 255, 255)`.
The test passes but we don't feel like we're finished yet.
How do we know that `hexToRgb` can handle _any_ valid hex color when we've only
tested it on one?
Maybe there's an edge case our implementation doesn't account for.
Maybe `hexToRgb` returns an `Err` for any hex color that isn't `#ffffff`.
We don't know until we write more tests.

But how do we write tests that account for "kinds" of input like hex colors 
rather than specific values like `"#ffffff"`?
We could simply generate all the valid hex color strings and write a test
that calls `hexToRgb` on all of them. 
But there are a lot of hex colors. 
In fact, there are [`16,777,216 + 4,096`](https://en.wikipedia.org/wiki/Web_colors) 
of them.

Instead, we decide to take this idea and scale it down. 
Instead of generating millions of hex colors, we generate 75 or a 100. 
And we generate these hex colors randomly each time the test runs. 
It doesn't matter that the hex colors are different each time the test runs
because we're not testing the conversion itself.
We just want to test that nothing unexpected happens when we call `hexToRgb`
with a valid hex color.

This method of testing is called property testing or "fuzz" testing. 
Fuzz testing requires us to think more generally about our inputs.
Instead of defining specific inputs like `#ffffff`, we define something
that generates a kind of value, in this case, a valid hex color.

The `Fuzz` module gives us a set of primitive fuzzers and some helper functions
that can be used to compose fuzzers to create new fuzzers.
So we've got a fuzzer that generates a random `Bool`, or `Int`, or `String`, etc.
None of these are what we want. 
They're too generic.
We're going to have to build our own hex color fuzzer.
We do that by writing smaller fuzzers and composing them.
So we need to break "valid hex color" into smaller parts that can be represented
by the tools we have.
Later, we'll connect these parts into a bigger "valid hex color" fuzzer.


## Thinking in patterns with formal grammar

We can identify these little building blocks by describing a valid hex color.
How do we describe a valid hex color? 
We can start by listing all the characteristics of a valid hex color in plain English
(or German or Esperanto or Morse code).
A hex color is:

- A string.
- The first character is always `#`.
- Every character after the first is a valid hexadecimal digit:
  - numbers 0 to 9;
  - letters A to F;
  - alphabetic characters can be upper or lowercase.
- The hexadecimal is three digits or six digits.

This wasn't too hard to describe. 
But the problem with using natural language is that its meaning can be ambiguous. 
For example, I forgot to mention in the list above that a hexadecimal number 
does not include any whitespace. 
Maybe you knew about the whitespace too. 
Maybe everyone knows about the whitespace. 
Or maybe I am the only one who knows about the whitespace.
So I add another item to the list that says "No whitespace".
But now I have to define what I mean by whitespace.
So the list gets longer and the requirements become more verbose, and 
misintepretation becomes more likely.
We find ourselves reaching for a language with less ambiguity, less possible
meanings, and less words required to say what we mean.

This is where a formal grammar becomes useful.
At this point it feels like we are very far away from our original task,
which was to generate some random valid hex values.
We don't really need a formal grammar for that, do we?
We can get the job done without it.
That's absolutely true.
It's a worthwhile exercise because it will give us an intuition for how to 
structure our fuzzers.

A formal grammar uses patterns of symbols to describe a set of valid strings.
Let's say that I have four strings, "aa", "AA", "aA" and "Aa". 
I want to say that, in my language, these are the only four "sentences".
Here's how I would say that with a formal grammar:

```
Start = Char, Char

Char = "A" | "a"
```

There are two types of symbols in formal grammar: terminal and nonterminal.
The names terminal and nonterminal imply action or movement.
A terminus is where something stops or ends.
In this case, the action or movement is replacement.
Given a nonterminal symbol, we want to replace it with a terminal symbol.

This game of replacement begins at the `Start` nonterminal symbol.
In any formal grammar, you will find a special symbol called something
like `Start` or `Root`.
This is the entry point to the grammar.
All valid strings converge at that symbol.

Let's walk through the process of testing whether `"aA"` is a valid sentence
in the language we've described.
We take the first character in `"aA"` which is `"a"`.
Then we look at the right side of the start symbol, moving left to right.
The first thing we encounter is the nonterminal symbol `Char`. 
In order to test whether `"a"` matches `Char`, we have to replace `Char` with
a terminal symbol.
To do this, we go down to the definition of `Char`. 
On the right side of `Char`, we first find `"A"`. 
`"A"` does not match `"a"`. 
But `"A"` is not our only option. 
The pipe operator (`|`) is the logical OR. 
So `Char` can also be replaced with `"a"`.
`"a"` matches `Char`. 
Now we repeat the process for the second `Char` on the right side of`Start`.
In the same way, we find that `"A"` matches `Char`.
And the concatenation operator (`,`) indicates that both `Char`s in `Start` are
part of one string.
So, `"aA"` is a valid sentence in our language.
`"bA"` is not, because there's no way to replace any of the nonterminal symbols
in our grammar with the terminal symbol `"b"`.


Now let's jump into writing a formal grammar for a hex color string.
We'll start with the basic pieces, the terminal symbols, and work our way up
to the `Start` symbol.

All hex colors are hexadecimal numbers.
So to write a grammar for a hex color, we first have to write a grammar
for a hexadecimal number.
A hexadecimal number is any combination of sixteen digits.
These digits are the integers 0 through 9 and the letters A through F.
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

That's easy enough.

The letters are slightly more complicated because any letter can be lowercase
or uppercase. We describe this by creating a nonterminal symbol for each
letter and then joining these in an `Alpha` symbol. 

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

In a similar fashion, we join `Num` and `Alpha` in a `HexDigit` symbol, our
first building block.

```
Hex1
 = Alpha
 | Num
```

Another low-hanging fruit is the `#` symbol.
Every hex color (in our grammar) starts with a hash sign.
This will be our second building block.

```
Hash = "#"
```

Now we start building patterns. Hex colors can use a six-digit or a three-digit
format.
Both formats are different patterns of our `Hash` and `Hex1` building
blocks.
We'll worry about adding the hash later. 
For now, we'll focus on building the patterns of hex digits.

```
Hex3 = Hex1, Hex1, Hex1

Hex6 = Hex3, Hex3
```

So now we have all the building blocks we need to construct our start symbol.

```
Start 
  = Hash, Hex3 
  | Hash, Hex6
```

All together, here is the grammar:

```bnf
HexColor 
  = Hash, Digit3
  | Hash, Digit6

Hash = "#"

Digit6 = Digit3, Digit3

Digit3 = Digit1, Digit1, Digit1

Digit1 = Num | Alpha

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

## Structuring patterns with Fuzzer combinators

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

```elm
one : Fuzzer String
one =
  Fuzz.constant "1"
```

Then we can use `Fuzz.oneOf` to combine each of our letter and number fuzzers
to create a `Fuzzer` that will generate one of these strings randomly.

```elm
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

```elm
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

```elm
digit3 : Fuzzer String
digit3 =
  Fuzz.map3 (\a b c -> a ++ b ++ c) digit1 digit1 digit1
```

Let's take a moment to extract some helper functions.


```elm
repeat2 : Fuzzer String -> Fuzzer String
repeat2 fuzzer =
    Fuzz.map2 (++) fuzzer fuzzer

repeat3 : Fuzzer String -> Fuzzer String
repeat3 fuzzer =
    Fuzz.map2 (++) fuzzer <| repeat2 fuzzer
```

Now we can use these abstractions to simplify the `digit3` fuzzer and create 
a `digit6` fuzzer.

```elm
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


```elm
hex : Fuzzer String
hex =
  Fuzz.oneOf
    [ hex3
    , hex6
    ]
```

Finally we add the hash to the front of this unknown, random hexadecimal number.
Now we have a fuzzer that generates random, valid hexadecimal color strings.

```elm
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
