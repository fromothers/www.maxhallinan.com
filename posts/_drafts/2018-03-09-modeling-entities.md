---
layout: post
title: "Modeling order and uniqueness with easy random access"
published: false
tags: [elm, programming]
---

A list of entities is a common user interface feature.
For example, a todo app is essentially a list of todos.
These lists are often sortable.

Sometimes the sorting logic is delegated to a remote data source, e.g. the 
todos API.
When the user sorts the list, the client passes those parameters to the API and 
receives a new set of entities.
Then it is important that the order of the collection is preserved.
Without knowing that order, the client has to re-sort the collection before 
showing it to the user.
This might be trivial for simple sort parameters but for complex sorts, the 
client might be duplicating non-trivial logic owned by the data source.
So it can be preferrable to preserve the order information.

But it is often not preferrable to model a collection of entities as a simple 
ordered collection like an array or a list.

These user interfaces often enable the user to sort and filter the list.
Sometimes the client kk
It is often advisable to delegate the sorting and filtering logic to data's 
source.

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
