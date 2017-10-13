---
layout: base
---

# Max Hallinan

[home](/) / [github](https://github.com/maxhallinan) / [email](mailto:maxhallinan@riseup.net)


netheless, an object is only called *iterable* if it has a `Symbol.iterator` method and that method returns an object conforming to the iterator protocol. The primacy of `Symbol.interator` is understood in the context of iterable consumption.

## Consuming an iterable

Because iterable is not a type, iterable-consuming constructs need a standard way to identify iterables and a standard source for the iterator. `Symbol.iterator` is this standard.

### Built-in iterable consumers

ECMAScript specifies several built-in iterable consumers. These consumers are sugary syntaxes for accessing an object's iterable values. Internally, these constructs first call the iterable's `Symbol.iterator` method and then call `next` on the returned iterator until `done` is `true`. Two commonly used iterable consumers are the `for...of` loop and the spread operator.

#### `for...of` loop

{% highlight javascript %}
  const arr = ['foo', 'bar', 'baz'];

  const log = x => console.log(x) || x;

  const getIterator = iterable =>
    iterable[Symbol.iterator] && iterable[Symbol.iterator]();

  const iterate = (callback, iterator) => {
    const { done, value } = iterator.next();

    if (done) {
      return value;
    }

    callback(value);

    return iterate(callback, iterator);
  };

  iterate(log, getIterator(arr));
  // 'foo'
  // 'bar'
  // 'baz'
{% endhighlight %}

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


## Open source contributions

- [ascott1/bigSlide.js](https://github.com/ascott1/bigSlide.js/commit/903b68643f492590c2ebbc5f963250c9bae80981)

- [corysimmons/scrollTrigger.js](https://github.com/corysimmons/scrollTrigger.js/commit/9894d854077666f1f65ebc237ec10fadf2cadecb)

- [reactjs/redux](https://github.com/reactjs/redux/commits?author=maxhallinan)

- [sindresorhus/split-at](https://github.com/sindresorhus/split-at/commit/a5c2a4fe65c1cad96600c8826daf4a6339dc2c1b)

- [sindresorhus/strip-css-comments](https://github.com/sindresorhus/strip-css-comments/commit/130c41cf66dfee858b5426a05c0d45f8e9afddbb)

- [steveukx/git-js](https://github.com/steveukx/git-js/commits?author=maxhallinan)

- [yeoman/configstore](https://github.com/yeoman/configstore/commits?author=maxhallinan)
