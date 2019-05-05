---
layout: post
title: "What the hash?"
date: 2015-08-17 12:45:00
categories: ruby
author: Filip Defar
excerpt: "Let's take a look at a potential pitfall in Ruby's hashes."
---

Recently I came across a piece of ruby code that got me a bit puzzled.

Let's say we need a hash that has an array for each value. It would be reasonable
to create a hash that has an empty array as the default value instead of nil, right?
Ok let's try with this:

```ruby
hash = Hash.new([])
hash[:foo].push "Bar"
hash # => {}
```

Hmm ok. That does not seem to work very well. So did we store anything in that key?

```ruby
hash[:foo] # => ["Bar"]
```

Wait, so it is there?

```ruby
hash # => {}
```

Aaaaand it's gone. What the cabbage?

Let's check the documentation for _Hash.new_.

> Returns a new, empty hash. If this hash is subsequently accessed by a key that doesn't correspond to a hash entry, the value returned depends on the style of new used to create the hash. In the first form, the access returns nil. **If obj is specified, this single object will be used for all default values.**

So if we specify an object as a default value, that single instance will always be
returned for unknown keys. If we modify that instance, then modified version will be returned.
So when we did this:

```ruby
hash[:foo].push "Bar"
```

We accessed that default object and modified it. But we have never set a value for the ":foo" key.
Reading a value from a hash does not modify the hash itself, even when the default value is set.
And that's why we get back an empty hash.

However, if we access the ":foo" key, we get our array with
"Bar" string in it, because that's the new default value. Actually if we access any other key that does not exist, we will get that same array.

```ruby
hash[:fiz] # => ["Bar"]
```

So for this specific use case, we should use the third option when creating a new hash,
and that's using a block. According to Ruby documentation, this should work properly.

> If a block is specified, it will be called with the hash object and the key, and should return the default value. It is the block's responsibility to store the value in the hash if required.

```ruby
hash = Hash.new { |hash, key| hash[key] = [] }
hash[:foo].push "Bar"
puts hash # => { :foo => ["Bar"] }
```

In this case, we assign a new value for the default key by merely accessing it, and this works as expected.

However, this might not be a very wise idea, modifying a hash when someone tries to read a value seem like a pretty unexpected behaviour and might confuse your fellow developers, or future you.
