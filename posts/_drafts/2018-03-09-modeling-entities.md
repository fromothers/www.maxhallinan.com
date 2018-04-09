---
layout: post
title: "Modeling order and uniqueness with easy random access"
published: false
tags: [elm, programming]
---

- Get a collection of `People` in alphabetical order.
- Get a collection of data from an API ordered by `name`.
- I want to preserve the order information (order).
- I want each entity to appear in the collection only once (unique).
- I want it to be as easy as possible to select one entity at random.
- I want to filter without dumping the collection.
- A `Set` gives me uniqueness but not order or random access.
- A `List` or an `Array` gives me order but not uniqueness or random access.
- A `Dict` gives me random access and uniqueness.
- An `OrderedDict` gives me all three.
- Implementing
