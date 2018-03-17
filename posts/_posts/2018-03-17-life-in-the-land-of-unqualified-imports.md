---
layout: post
tags: [elm, programming]
title: "Life in the land of unqualified imports"
---

## I.

Unqualified imports might be more readable than qualified imports.
But unqualified imports are more trouble than qualified imports.
Readability should not be confused with clarity.
The trouble is that unqualified imports are unclear.

## II.

I'm debugging some Elm code that I didn't write.
The file is 649 lines because large files are encouraged.<sup><a id="ref-1" href="#cite-1">1</a></sup>
I arrive at line 475 where an unfamiliar function is called.
I want to know what the function does.
Now I must jump to the top of the file and hunt for this function name among
the import declarations.
There are sixteen import declarations.
Three declarations use this form: `import Foo exposing (..)`.
So I must look for the function in all three libraries, hoping I find it in the
first one.
In the end, I've forgotten what I was doing on line 475.

## III.

The fallacy of the unqualified import is that small, simple names are more
"readable".
Here is an example from the popular Elm library 
[NoRedInk/elm-decode-pipeline](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/3.0.0).

{% highlight elm %}
userDecoder : Decoder User
userDecoder =
  decode User
    |> required "id" int
    |> required "email" (nullable string)
    |> optional "name" string "(fallback if name is `null` or not present)"
    |> hardcoded 1.0
{% endhighlight %}

This is meant to be code that reads like a plain-English description of what it
does.
The code is considered readable because I can scan these lines and understand 
that a `User` is required to have an id and an email address but not a name.
Functions `required`, `optional`, and `hardcoded` are composed like words
into sentences that describe the underlying domain model.

Qualified imports ruin the effect.

{% highlight elm %}
    |> Json.Decode.Pipeline.required "id" int
    |> Json.Decode.Pipeline.required "email" (nullable string)
    |> Json.Decode.Pipeline.optional "name" string "(fallback if name is `null` or not present)"
    |> Json.Decode.Pipeline.hardcoded 1.0
{% endhighlight %}

What was once Elm poetry is now just Elm code.

I am gratified by the poetry when I don't need to deeply understand the
code.
But if I need to know about `int` or `string`, I am easily confused.
I might guess that those functions are exported by `Json.Decode.Pipeline`.
In fact, they are not.
Those functions belong to `Json.Decode`.
And these libraries are commonly used in the same context.
Without qualified imports, I am constantly jumping to the import declarations or 
guessing about where to look for documentation.

## IV.

Maybe readability can be preserved and confusion mitigated by using an import
alias.

{% highlight elm %}
    |> P.required "id" D.int
    |> P.required "email" (D.nullable D.string)
    |> P.optional "name" D.string "(fallback if name is `null` or not present)"
    |> P.hardcoded 1.0
{% endhighlight %}

This compromise might appeal to the developer who is enamored with small, simple
function names.
I am doubtful that this compromise means less jumping to the top of a file.
The code is clarified by the alias only when I have memorized every alias in
the file.
And that clarity lasts only as long as I can maintain the memorization.

## V.

Aliased module imports breed their own trouble.
What if someone chooses an odd alias?
Humans are not dependably clear thinkers.
People inexplicably call a `Foo.Bar` a `Baz`.
And what if two modules are reasonably referred to by the same alias?
`Foo` might be `Data.Foo` or `View.Foo`.
So I'm still jumping to the import declarations like a dog rummaging through 
dead leaves looking for a chicken bone.

## VI.

Traversing the file is not hard.
My hand mostly remembers to set a mark before making the jump.<sup><a id="ref-2" href="#cite-2">2</a></sup>
Marks make the round trip between call site and import declaration pretty quick.
So I am not trying to save myself key strokes.
I _am_ trying to save myself from thinking.

I don't want to think about "where does this function come from?".
I don't want to think about "does `S` mean `Set` or `String`?".
I don't want to think about a reasonable alias for `Foo.Bar.Baz`.
I just want to know immediately where this unfamiliar function comes from so 
that I can get on with my work.
The full module name, however long, is the only name guaranteed to give me 
useful information.

## VII.

I have recently conceded that qualified and unqualified imports are both 
appropriate, depending on the context.
I conceded this to end an argument that was lasting too long.
Privately, I remain a qualified import absolutist.

Rules are useful to the degree that they can be applied consistently.
"Always qualify imports with the full module name" is a useful rule because it 
can be followed consistently.
"Depending on the context" is not a useful rule because it invokes a personal 
judgment, the result of which is not dependably consistent.

## VIII.

What is gained by inviting the spectre of the subjective when it can be avoided?
Why must code be self-expressive one degree more than it necessarily is.

**Notes**

<ol>
  <li id="cite-1">
    <a href="https://www.youtube.com/watch?v=XpDsk374LDE">
      The life of a file
    </a>
    by Evan Czaplicki
    <sup>
      [<a href="#ref-1">Return</a>]
    </sup>
  </li>
  <li id="cite-2">
    <a href="vim.wikia.com/wiki/Using_marks">
      Vim Tips Wiki: Using marks
    </a>
    <sup> 
      [<a href="#ref-2">Return</a>]
    </sup>
  </li>
</ol>
