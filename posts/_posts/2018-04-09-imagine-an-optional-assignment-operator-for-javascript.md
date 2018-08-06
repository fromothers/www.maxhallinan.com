---
layout: post
title: "Imagine an Optional Assignment Operator for JavaScript"
tags: [javascript, plt]
---

Today I wrote some JavaScript like this:

{% highlight javascript %}
let foo = null;

if (bar) {
  foos = await getFoos();

  if (foos.length) {
    foo = foos[0];
  }
}
{% endhighlight %}

The last three lines use a lot of syntax to communicate a simple intent.
First `foo` is initialized to `null`, signalling that there is no `Foo`.
Then the code attempts to get some Foos.
The intent is to reassign `foo` only when `getFoos` produces a `Foo`.
If `getFoos` produces an empty array, there is no reason to change the 
assignment.

I wonder if it would be nice to have an "optional assignment" operator for a 
moment like this.
An optional assignment operator would change the assignment only when an 
arbitrary expression has a truthy evaluation.
Here's a hypothetical syntax:

{% highlight javascript %}
let foo = null;

if (bar) {
  foos = await getFoos();

  foo =? foos.length : foos[0];
}
{% endhighlight %}

This is almost a ternary expression but it saves me from having to provide the
initial value on the right side of the expression.

{% highlight javascript %}
// ternary expression
foo = foos.length ? foos[0] : null;
// or 
foo = foos.length ? foos[0] : foo;

// optional assignment expression
foo =? foos.length : foos[0];
{% endhighlight %}

Only the optional assignment operator enables me to communicate my intent 
exactly.

## Afterword

The premise of my example is that I mean to write code in an imperative style
with mutable assignment.
Other styles of programming suggest other ways to model a nullable value.
Some of those ways render an optional assignment operator unnecessary.
The `Maybe` monad from functional programming is one example.

There are also other ways to use less characters to implement roughly the same
logic.
For example: 

{% highlight javascript %}
let foo;
foo = foos[0]; 
{% endhighlight %}

Here `undefined` is used to signal the absence of value.
I prefer `null` for this purpose.
When null values are literally `null`, then I can depend on `undefined` to 
indicate something broken or unexpected.

Another example is:

{% highlight javascript %}
let foo = null;
foo = foos[0] || null; 
{% endhighlight %}

This works only if `foos[0]` is expected to be truthy.
An array of booleans containing `false` would break this logic.
