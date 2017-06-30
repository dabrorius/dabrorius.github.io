---
layout: post
title:  "A crash course to D3.js"
date:   2017-06-28 12:45:00
categories: tutorial
author: Filip Defar
excerpt: "This tutorial is intended to people who already understand basic front-end programming concepts and want to quickly understand basics of D3.js"
---
If you are a Javascript developer that crashed on an alien planet and are held hostage by a race of space badgers who demand that you build a D3.js chart for them in next 15 minutes - this is a tutorial for you. Let's start!

> D3 allows you to bind arbitrary data to a Document Object Model (DOM), and then apply data-driven transformations to the document.

Let's select all `<div>` tags on the page and bind an array of integers to it.

```javascript
d3.selectAll('div').data([40,100,55,120])
```

If we hard-code four `<div>` tags on that page we can use the values specified in `data()` to set their attributes.
We will be using the `text()` method which sets the content of an HTML element.

The value that is bound to the current element will be passed as a first argument of the function that's passed to `text()`. If you are extremely confused at this point just look at this example and try not to think about the space badgers.

<p data-height="265" data-theme-id="0" data-slug-hash="mwpgKr" data-default-tab="js,result" data-user="dabrorius" data-embed-version="2" data-pen-title="mwpgKr" class="codepen">See the Pen <a href="https://codepen.io/dabrorius/pen/mwpgKr/">mwpgKr</a> by Filip Defar (<a href="https://codepen.io/dabrorius">@dabrorius</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

In a similar way, we can modify other attributes of selected elements.

<p data-height="265" data-theme-id="0" data-slug-hash="VWyoJj" data-default-tab="js,result" data-user="dabrorius" data-embed-version="2" data-pen-title="D3 crash course - example 2" class="codepen">See the Pen <a href="https://codepen.io/dabrorius/pen/VWyoJj/">D3 crash course - example 2</a> by Filip Defar (<a href="https://codepen.io/dabrorius">@dabrorius</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Usually, you will want to select something more specific. For example all `<div>` elements within some other element.
You can chain the selectors to get a more specific selection.

```javascript
d3.select('#chart').selectAll('div').data([40,100,55,120])
```

We could be using an SVG element instead of `<div>` elements - there's really no difference. But because time is of the essence let's just stick with `<div>`s and use some CSS to make it look half-decent. We're using ES6 we can use the [arrow functions](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Arrow_functions) to tidy up the code.

<p data-height="265" data-theme-id="0" data-slug-hash="ZyrzEZ" data-default-tab="js,result" data-user="dabrorius" data-embed-version="2" data-pen-title="D3 crash course - example 3" class="codepen">See the Pen <a href="https://codepen.io/dabrorius/pen/ZyrzEZ/">D3 crash course - example 3</a> by Filip Defar (<a href="https://codepen.io/dabrorius">@dabrorius</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Much better!
Let's make it a bit more dynamic, it will help us understand how things work. 

Instead of having a hard-coded value for `dataset` let's pull it out from an input field.
For the sake of simplicity, we can just use `split()` to convert it from a string to an array of values.

We also need to wrap our whole code in a function and then set it as `onClick` action for the update button.
Try clicking it and changing the values in the input box and see what happens.

<p data-height="265" data-theme-id="0" data-slug-hash="jwZNMX" data-default-tab="js,result" data-user="dabrorius" data-embed-version="2" data-pen-title="D3 crash course - example 4" class="codepen">See the Pen <a href="https://codepen.io/dabrorius/pen/jwZNMX/">D3 crash course - example 4</a> by Filip Defar (<a href="https://codepen.io/dabrorius">@dabrorius</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

You will notice that there are always exactly four bars, even before we click the update button.
This is because we hard-coded them into the page during the first step.

Until now we only used the default (a.k.a. update) selection, which contains the elements for which we have both data and matching DOM elements.

To add new bars we will use the `enter()` selection. This selection contains 'ghost' elements for each dataset value that does not have a matching element. (*This is not a completely correct explanation, but it's good enough for now.*). We can then use `append()` to add the missing elements.

This also means that we don't have to hard-code any `<div>` tags into the DOM, so the root element of our chart can now be just `<div id='chart'></div>`.

<p data-height="430" data-theme-id="0" data-slug-hash="BZYavN" data-default-tab="js,result" data-user="dabrorius" data-embed-version="2" data-pen-title="D3 crash course - example 5" class="codepen">See the Pen <a href="https://codepen.io/dabrorius/pen/BZYavN/">D3 crash course - example 5</a> by Filip Defar (<a href="https://codepen.io/dabrorius">@dabrorius</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

We still need to remove the extra elements if the dataset is smaller than the number of DOM elements. This is where the `exit()` selection kicks in. In this case, we don't have to change any attributes so a simple call to `remove()` will be good enough.

```javascript
selection.exit().remove()
```

And that's it, you are saved from the badgers and can return home. Here is the final result:

<p data-height="520" data-theme-id="dark" data-slug-hash="BZYaej" data-default-tab="js,result" data-user="dabrorius" data-embed-version="2" data-pen-title="D3 crash course - example 6" class="codepen">See the Pen <a href="https://codepen.io/dabrorius/pen/BZYaej/">D3 crash course - example 6</a> by Filip Defar (<a href="https://codepen.io/dabrorius">@dabrorius</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>








