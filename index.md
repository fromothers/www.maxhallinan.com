---
layout: base
---

## Posts

{% for post in site.categories.posts %}
  - {{ post.date | date_to_string }} [{{post.title}}]({{post.url}})
{% endfor %}


## Projects

- [brunfaick](https://github.com/maxhallinan/brunfaick): A Brainfuck interpeter
  implemented in JavaScript.

- [git-chipper](https://github.com/maxhallinan/git-chipper): An interactive CLI
  for batch deleting local branches.

- [kontext](https://github.com/maxhallinan/kontext): A higher-order function that
  proxies context to context-free functions.

- [kreighter](https://github.com/maxhallinan/kreighter): A utility for generating
  Redux action creators.

- [my-clippings-to-json](https://github.com/maxhallinan/my-clippings-to-json):
  Format Kindle clippings as JSON.

- [redeuceur](https://github.com/maxhallinan/redeuceur): A utility for creating
  terse Redux reducers.

- [reshep](https://github.com/maxhallinan/reshep): A higher-order component
  that "reshapes" a React component props object.

- [zelektree](https://github.com/maxhallinan/zelektree): Embed selectors in a 
  Redux state tree.


## Open source contributions

- [ascott1/bigSlide.js](https://github.com/ascott1/bigSlide.js/commit/903b68643f492590c2ebbc5f963250c9bae80981)

- [corysimmons/scrollTrigger.js](https://github.com/corysimmons/scrollTrigger.js/commit/9894d854077666f1f65ebc237ec10fadf2cadecb)

- [reactjs/redux](https://github.com/reactjs/redux/commits?author=maxhallinan)

- [sindresorhus/split-at](https://github.com/sindresorhus/split-at/commit/a5c2a4fe65c1cad96600c8826daf4a6339dc2c1b)

- [sindresorhus/strip-css-comments](https://github.com/sindresorhus/strip-css-comments/commit/130c41cf66dfee858b5426a05c0d45f8e9afddbb)

- [steveukx/git-js](https://github.com/steveukx/git-js/commits?author=maxhallinan)

- [yeoman/configstore](https://github.com/yeoman/configstore/commits?author=maxhallinan)
