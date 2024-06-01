---
title: "Splat, splat and double splat!"
date: 2019-05-05 11:30:00
categories: ruby
author: Filip Defar
excerpt: "We run into splat operators often, so I wanted to take some time and explore them in a bit more depth."
---

Ruby has a quite flexible way of defining methods that accept arbitrary number of arguments.
We run into splat operators often, so I wanted to take some time and explore them in a bit more depth.

Let's start with a question that might intrigue you into exploring this topic.
If we have the following method call:

```ruby
my_method('Go', 'Now', name: 'John Goblikon')
```

What will be assigned as arguments when the method is defined in following ways?

```ruby
def my_method(*args)
```

```ruby
def my_method(**args)
```

```ruby
def my_method(*args1, **args2)
```

Let's find out!

## Splat operator (\*)

Splat operator allows us to convert an `Array` to a list of arguments and vica versa.

Let's look at an example function that takes arbitrary number of arguments.

```ruby
def things_i_like(*things)
  things.each { |thing| puts "I like #{thing}" }
end
```

We can call this method like this:

```ruby
things_i_like('pie', 'doggos', 'grog')
# => I like pie
# => I like doggos
# => I like grog
```

All passed arguments will be collected into an `Array` and passed as a single argument named `things`.

```ruby
things # => ["pie", "doggos", "grog"]
things.class # => Array
```

### Mixing it up

We can also define regular positional parameters in combination with a splat parameter.

```ruby
def likes(main_interest, *others)
  puts "I like #{main_interest} the most!"
  others.each do |other|
    puts "I also like #{other}"
  end
end
```

```ruby
likes('pokemon', 'cats', 'chairs')
# => I like pokemon the most!
# => I also like cats
# => I also like chairs
```

This type of parameters is called "positional parameters" for a reason - the order of arguments decides how they will be assigned.

In this case, the first argument is separated from the rest. However, the splat argument does not have to be the last argument. Doing something like this is completely acceptable:

```ruby
def likes(main_interest, *others, last_one)
```

However, there is a limit to how crazy we can get. It is not allowed to have more than one splat parameter in the same method.

```ruby
def likes(main_interest, *others, last_one, *and_some_more)
# => syntax error, unexpected *
```

### Putting it in reverse

The splat operator also works the other way around.
It can convert an `Array` into a list of arguments!

```ruby
def three_things_i_like(a, b, c)
  puts "I like #{a}, #{b} and #{c}."
end
```

We can now call this method with three arguments as usual.

```ruby
three_things_i_like('pie', 'doggos', 'grog')
```

However, we can use the splat operator to pass in an `Array` instead.

```ruby
array_of_likes = %w(pie doggos grog)
three_things_i_like(*array_of_likes)
```

This can be quite useful. but we should be cautious! If the array does not have exactly three elements we will get an `ArgumentError`.

```ruby
array_of_likes = %w(pie doggos)
three_things_i_like(*array_of_likes)
# =>  wrong number of arguments (2 for 3) (ArgumentError)
```

### Named parameters

Ruby 2.0 introduced keyword arguments, and splat argument works with them. Splat argument always creates an `Array`, and all unmatched keyword arguments will be collected in a `Hash` that will be the last element of that array.

```ruby
def splat_test(*args)
  args
end
```

```ruby
splat_test('positional')
# => ['positional']
```

```ruby
splat_test('positional', foo: 'bar')
# => ['positional', {:foo=>"bar"}]
```

```ruby
splat_test(foo: 'bar')
# => [{:foo=>"bar"}]
```

The single splat operator works in reverse even for named parameters. We just need to add a `Hash` as the last element of the array.

```ruby
def introduction(title, name:, surname:)
  puts "Hello #{title} #{name} #{surname}"
end
```

```ruby
args = ['Mr.', { name: 'John', surname: 'Goblikon' }]
introduction(*args)
```

## Double splat operator (\*\*)

Double splat operator works similar to the splat operator, but it only collects keyword arguments. For this reason, it always generates a `Hash`, not an `Array`.

```ruby
def do_something(**options)
  options.each { |k, v| puts "Options #{k}: #{v}" }
end
```

```ruby
do_something(color: 'green', weight: 'bold')
# => Options color: green
# => Options weight: bold
```

```ruby
things # => {:color=>"green", :weight=>"bold"}
things.class # => Hash
```

Double splat operator will collect only named arguments that were not matched to regular parameters. This behavior is similar to the single splat operator, but instead of relying on the position of arguments it relies on their names.

```ruby
def do_something(action:, **options)
  puts "Action: #{action}"
  options.each { |k, v| puts "Options #{k}: #{v}" }
end
```

```ruby
do_something(action: 'print', color: 'green', weight: 'bold')
# => Action: print
# => Options color: green
# => Options weight: bold
```

Double splat operator also works in reverse. You can convert a `Hash` into named parameters.

```ruby
def print_multiple(value:, count:)
  count.times { puts value }
end
```

```ruby
hash_params = { value: 'Hello', count: 3 }
print_multiple(**hash_params)
# => Hello
# => Hello
# => Hello
```

It's important to notice that keys of that hash must be symbols. They can't even be strings.

```ruby
hash_params = { 'value' => 'Hello', 'count' => 3 }
print_multiple(**hash_params)
# => wrong argument type String (expected Symbol) (TypeError)
```

## Using both splat operators

You can mix both splat and double splat parameters within the same method.

If both are present at the same time, the single splat operator will collect only positional arguments while the double splat operatr will behave as usual. It will collect all unmatched named arguments.

```ruby
def can_you_do_this?(*positional, **named)
  puts positional
  puts named
end
```

```ruby
can_you_do_this?('first', 'second', name: 'john', surname: 'doe')
# => first
# => second
# => {:name=>"john", :surname=>"doe"}
```

You can define positional, splat, keyword and double splat parameters inside the same method. However, the order is important here. Keyword arguments need to go after positional arguments, and the double splat operator must be at the very end.

```ruby
def can_you_do_this?(first, *positional, second, name:, **named)
# This is perfectly ok!
```

## Conclusion

Even though it might look a bit intimidating at first, the splat operator logic is actually quite straightforward.

Just keep in mind that:

- Regular arguments have precedence and will be assigned first.
- Double splat always works only on named arguments.
- Single splat collects both positional and named arguments unless there's also a double splat parameter defined in the same method.

## Solution

So to answer the question from the beginning. What will happen with this method call?

```ruby
my_method('Go', 'Now', name: 'John Goblikon')
```

### Example 1

The first method is ok and it will collect all arguments into an `Array`, with named arguments stored as a `Hash`.

```ruby
def my_method(*args)
# args => ['Go', 'Now', {name: 'John Goblikon'}]
```

### Example 2

The second example is invalid, we are only collecting named arguments while two positional arguments are passed to the method. We will get an `ArgumentError`.

```ruby
def my_method(**args)
# wrong number of arguments (2 for 0) (ArgumentError)
```

### Example 3

The third example is again valid. This time the single splat argument will collect only positional arguments, while the double splat will collect the named arguments.

```ruby
def my_method(*args1, **args2)
# args1 => ['Go', 'Now']
# args2 => {name: 'John Goblikon'}
```
