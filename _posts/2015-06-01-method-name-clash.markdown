---
layout: post
title:  "Two modules, one method"
date:   2015-06-01 21:26:00
categories: jekyll update
---
I recently had an interview for a Ruby on Rails developer position and have been
asked a lot of interesting (and somewhat difficult) questions. They required
some solid knowledge of how Ruby works. One of those questions was following:

Say we have two modules with a method with the same name in both of them.

{% highlight ruby %}
module Wolf
  def speak
    puts "Auuu!"
  end
end

module Dog
  def speak
    puts "Woof!"
  end
end
{% endhighlight %}

And we include them both to a class, create an instance of that class and call
that method. What will happen?

{% highlight ruby %}
class Mutant
  include Dog
  include Wolf
end

m = Mutant.new
m.speak
{% endhighlight %}

In this case, the method from _Wolf_ module will be called and output will be "Auuu!".
Let's see why and how this happens.

When a method is called Ruby interpreter will first look if that method is defined on that object's class. If it didn't find the right method there, it will check that class's superclass. It will keep moving this way up until it finds the right method. This chain of superclasses is called _ancestors chain_. In case method was not found on any class in the ancestors chain,
_method_missing_ method will be called (and it will raise NoMethodError by default).

But what about modules?

Let's first take a look at ancestors chain of our _Mutant_ class by calling _ancestors_ method.

{% highlight ruby %}
Mutant.ancestors
 => [Mutant, Wolf, Dog, Object, Kernel, BasicObject] 
{% endhighlight %}

So we have _Mutant_ class here as expected, we also have _Object_ and _BasicObject_
which are classes defined by Ruby that all other classes inherit from. But there
are also modules here. There's _Wolf_ and _Dog_ that we defined, and _Kernel_ which is
included by default in all Ruby classes.

So how did the modules get here? When you call _include_ in ruby it
will wrap that module in an anonymous class and add it in the ancestral chain right
above the current class.

So when we included _Dog_, it got wrapped in a class and
_Mutant_ class inherited from it. It was set above _Mutant_ and below _Object_ in ancestors chain.
When we included _Wolf_, it pushed _Dog_ up and got added right above _Mutant_ in
the ancestor chain.

We got a response from Wolf module because it's first in
the ancestors chain. Ruby interpreter will first check if that module has _speak_ class, it will find it there and won't look any further.
If we included the modules in different order, the other method would be called.
