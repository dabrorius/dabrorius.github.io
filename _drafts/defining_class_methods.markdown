Class methods - a definitive guide

So you probably know that there are multiple different ways of defining class
methods in ruby.

class Foo
  def Foo.bar
    puts "Hello!"
  end
end

class Foo
  def self.bar
    puts "Hello!"
  end
end

So the first two seem resonable, but there's also the third one that's a bit
cryptic.

class Foo
  class << self
    def bar
      puts "Hello!"
    end
  end
end

So what the hell does that even mean?

