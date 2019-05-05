# def can_you_do_this?(*positional, **named)
#   puts positional
#   puts named
# end

# can_you_do_this?('first', 'second', name: 'john', surname: 'doe')

# def can_you_do_this?(_first, *positional, _second, name:, **named)
#   puts positional
#   puts named
#   puts first
#   puts second
# end

# can_you_do_this?('first', 'second', name: 'john', surname: 'doe')
def splat_test(*args)
  puts args.class
  puts args
end

puts '----'
splat_test('positional', foo: 'bar')

puts '----'
splat_test('positional', foo: 'bar')

puts '----'
splat_test(foo: 'bar')
