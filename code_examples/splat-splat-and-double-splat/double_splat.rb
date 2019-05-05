# puts 'Double'

# def do_something(**options)
#   puts options
#   puts options.class
#   options.each { |k, v| puts "Options #{k}: #{v}" }
# end

# do_something(color: 'green', weight: 'bold')

# def do_something(action:, **options)
#   puts "Action: #{action}"
#   options.each { |k, v| puts "Options #{k}: #{v}" }
# end

# do_something(action: 'print', color: 'green', weight: 'bold')

# def print_multiple(value:, count:)
#   count.times { puts value }
# end

# print_multiple(value: 'Hello', count: 3)

# hash_params = { value: 'Hello', count: 3 }
# print_multiple(**hash_params)

# hash_params = { 'value' => 'Hello', 'count' => 3 }
# print_multiple(**hash_params)

def nested_params(foo:)
  puts foo
end
nested_params(**{ foo: { boo: 'asd' } })
