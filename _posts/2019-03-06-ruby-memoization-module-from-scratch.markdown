---
layout: post
title: "Building a memoization module in Ruby"
date: 2019-03-14 12:30:00
categories: ruby
author: Filip Defar
excerpt: "How hard is it to build a memoization module from scratch in Ruby? Let's find out!"
---

A while ago during a job interview, I got asked to develop a generic memoization method in Ruby.
The goal is to be able to memoize a method by simply calling:

```ruby
memoize :my_awesome_method
```

This is not as hard as it might sound at first, but there's a lot of depth to this task and requires a decent Ruby metaprogramming knowledge.
This is why I decided to revisit this task in this blog post.

But, first of all, what is memoization anyway? Wikipedia says something like this:

> Memoization is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls and returning the cached result when the same inputs occur again.

Whenever a memoized method is called we take note of the parameters it was called with and the result it produced. If the same method is called again with the same parameters in the future, we skip the calculation and return the results that were produced last time.

Lets write an expensive method we can then try to optimize.

```ruby
class Snail
  def serve_tea(kind)
    sleep(2)
    "Here's a #{kind} tea for you!"
  end
end
```

We have a `Snail` class with a single method `serve_tea` that after 2 seconds of sleeping returns a string.

## The non-generic solution

First, let's implement memoization directly as a part of `serve_tea` method.

We can use a Hash as the cache store.
We will use the parameter that method was called with as a key and the result that is to be returned as a value.

```ruby
class Snail
  # Step 0: Initialize the cache store
  @@cache = {}

  def serve_tea(kind)
    # Step 1: Check if a return value for this parameter is already stored
    return @@cache[kind] if @@cache.key?(kind)

    # Step 2: Do whatever you used to do
    sleep(2)
    @@cache[kind] = "Here's a #{kind} tea for you!" # Step 3: Cache the result
  end
end

```

Intuitively we use a class variable for the cache store, this means all instances of snail will use the same cache. We will discuss this approach later in the text, but first, let's try to extract the memoization logic to a generic solution.

## Generic memoization method

When `memoize` method is called it needs to wrap the given method with memoization logic. The solution we are exploring here works in two steps. First, we store the to-be-memoized method in a variable, then we overwrite the original method with the memoized version. The memoized version of the method will call the original method that we stored in a variable.

We can do the first step by calling `instance_method` which returns an [UnboundMethod](https://ruby-doc.com/core-trunk/UnboundMethod.html) object. This way we created an object out of a method, we can store it in a variable and call it later via the `call` method.

The good thing is that subsequent changes to the underlying class do not affect the unbound method, which means that we are free to overwrite the original method and then call the unchanged variant from a variable. We can overwrite the original method simply by defining a new method with the same name as the old one.

This gives us all the tools necessary to create the generic `memoize` method.

```ruby
class Snail
  @@cache = {}

  def self.memoize(method_name)
    # Step 1: Objectify the method
    inner_method = instance_method(method_name)

    # Step 2: Overwrite the old method with the memoized version
    define_method method_name do |arg|
      return @@cache[arg] if @@cache.key?(arg)
      @@cache[arg] = inner_method.bind(self).call(arg)
    end
  end

  def serve_tea(kind)
    sleep(2)
    "Here's a #{kind} tea for you!"
  end
  memoize :serve_tea
end
```

## Extracting memoization method to a module

We defined `memoize` method as a class method directly on `Snail` class. If we want to use it in different classes we need to extract it to a module.

We will add this module to the `Snail` class using the `extend` keyword, not the `include` keyword because we want `memoize` to be a class method, not an instance method.

```ruby
module Memoize
  @@cache = {}
  def memoize(method_name)
    inner_method = instance_method(method_name)
    define_method method_name do |arg|
      return @@cache[arg] if @@cache.key?(arg)
      @@cache[arg] = inner_method.bind(self).call(arg)
    end
  end
end

class Snail
  extend Memoize
  def serve_tea(kind)
    sleep(2)
    "Here's a #{kind} tea for you!"
  end
  memoize :serve_tea
end
```

```ruby
snail_one = Snail.new
snail_two = Snail.new

puts snail_one.serve_tea('green') # Takes two seconds to calculate
puts snail_two.serve_tea('green') # Returns instantly, using the cached value
```

## Fixing the cache key

While the previous implementation seems to work properly, there are two significant issues with it.

First, we can only memoize methods that take a single parameter. If we try to expand our method like this

```ruby
def serve_tea(kind, sugar)
  sleep(2)
  "Here's a #{kind} tea #{sugar ? 'with' : 'without'} sugar for you!"
end
memoize :serve_tea
```

We won't be able to run the code.

```
`serve_tea': wrong number of arguments (given 1, expected 2) (ArgumentError)
```

We can fix this easily by using the splat operator. Splat operator will collect all arguments passed to this method and convert them to an array and then convert them back to the list of arguments when calling the inner method.

You will notice that now we are using an `Array` object as a `Hash` key for our cache object. This is perfectly fine because in Ruby, Hash allows you to use any object type as a key.

```ruby
module Memoize
  @@cache = {}
  def memoize(method_name)
    inner_method = instance_method(method_name)

    # *args will collect all arguments into an array
    define_method method_name do |*args|
      return @@cache[args] if @@cache.key?(args)

      # *args will convert the args Array object back into a list of arguments
      @@cache[args] = inner_method.bind(self).call(*args)
    end
  end
end
```

However, there is another issue with this implementation. We did not take into account the method name when caching the method result.
If we memoize two different methods that receive the same parameters we will cache and return incorrect results. Here's an example of that scenario.

```ruby
class Snail
  extend Memoize
  def serve_tea(kind)
    sleep(2)
    "Here's a #{kind} tea for you!"
  end
  memoize :serve_tea

  def serve_coffee(kind)
    sleep(2)
    "Here's a #{kind} coffee for you!"
  end
  memoize :serve_coffee
end
```

```ruby
snail_one = Snail.new
snail_two = Snail.new

puts snail_one.serve_tea('black') # => Here's a black tea for you!
puts snail_two.serve_coffee('black') # => Here's a black tea for you.
```

Even though the second call was to the `serve_coffee` method, our memoization module returned the results from the `serve_tea` method.

To fix this, we can build the cache key as an array where the first element is the method name and the second elements is an array of arguments.
While this key is quite complex, because Hash keys can be any object type, we are still fine.

```ruby
module Memoize
  @@cache = {}
  def memoize(method_name)
    inner_method = instance_method(method_name)
    define_method method_name do |*args|
      # Use both arguments and the method name as caching key
      key = [method_name, args]
      return @@cache[key] if @@cache.key?(key)
      @@cache[key] = inner_method.bind(self).call(*args)
    end
  end
end
```

## Inheritance woes

Our `Memoization` module uses a class variable as a cache store. Intuitively this seems like a good solution, however, we can easily run into issues.

```ruby
class Snail
  extend Memoize

  def serve_tea(kind)
    sleep(2)
    "Here's a #{kind} tea for you!"
  end
  memoize :serve_tea
end

class EvilSnail
  extend Memoize

  def serve_tea(kind)
    sleep(2)
    "Here's a POISONED #{kind} tea for you!"
  end
  memoize :serve_tea
end

evil_snail = EvilSnail.new
snail = Snail.new
puts evil_snail.serve_tea('green') # => Here's a POISONED green tea for you!
puts snail.serve_tea('green') # => Here's a POISONED green tea for you!
```

Oh no, we served a poisoned tea to the wrong person!
The issue here is that the cache class variable belongs to the `Memoize` module and is shared across classes that use that module. We can avoid that problem by replacing the class variable with a class instance variable, which is considered a good practice for this exact reason.

```ruby
module Memoize
  def memoize_cache
    @memoize_cache ||= {}
  end

  def memoize(method_name)
    inner_method = instance_method(method_name)
    define_method method_name do |*args|
      key = [method_name, args]
      cache = self.class.memoize_cache
      return cache[key] if cache.key?(key)
      cache[key] = inner_method.bind(self).call(*args)
    end
  end
end
```

Now each class that uses `Memoization` module will have its own instance variable that contains the cache. This will prevent cache mixup between sibling classes and will make tea safe to drink again.

## Conslusion

As with every other programming problem, the devil seems to be in the details. While we covered some edge cases in this blog post I would still not recommend using this soulution in a real world application as more issues are sure to be lurking behind the corner.

For a more complete solution, you can check out the [memoist](https://github.com/matthewrudy/memoist) gem.
