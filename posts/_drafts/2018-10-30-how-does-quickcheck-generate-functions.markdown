---
layout: post
published: true
title: "How Does QuickCheck Generate Functions?"
tags: [programming]
---

QuickCheck can generate random functions.
You specify the type and QuickCheck generates a function of that type.
The return value is random.

This is useful for testing the properties of higher-order functions.
For example, it's helpful to call `fmap` on a bunch of random functions to test
that the implementation is lawful.

{% highlight haskell %}
prop :: Fun String Integer -> Fun Integer String -> Maybe String -> Bool
prop (Fun _ f1) (Fun _ f2) x = 
  fmap (f2 . f1) x == (fmap f2 . fmap f1) x

runTest = quickCheck prop
{% endhighlight %}

I don't like magic in programming.
I only trust mechanisms that I understand.
It's hard to reason about something without knowing how it works.
QuickCheck's function generation seemed magical, but it also delighted me.
And since it is really useful, I kept using it without understanding it.

All the while, I was pretty sure of something interesting happening here.
Perhaps that was something generally useful.
It irked me that I didn't understand it.

I noticed that the implementation is based on a paper.
And when there's a paper involved, I tend to assume that this is Something I 
Might Not Understand.
I couldn't be sure, because the paper is behind a paywall.
So instead, I avoided the subject.

When I finally worked up the courage to peek at the code, I found that function 
generation is pretty simple.
What looked magical to me was based on principles I had already internalized.
If I had thought a little deeper, I could have guessed at the implementation.

So here's how QuickCheck generates random functions.

[Haskell Symposium 2012. Koen Claessen: Shrinking and showing functions](https://www.youtube.com/watch?v=CH8UQJiv9Q4)

## QuickCheck's API

### `Fun` type

`Fun a b` represents a function from `a` to `b`.
`Fun String Integer` represents a function that takes a String and returns an 
Integer.

```haskell
data Fun a b = Fun (a :-> b, b, Shrunk) (a -> b)
-- :-> is a type  
-- the second parameter is a callable function
```

`:->` is a generalized algebraic datatype.


```haskell
data a :-> c where
  Pair 
```

### Questions

1. What is a generalized algebraic datatype?
