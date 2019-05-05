def three_things_i_like(a, b, c)
  puts "I like #{a}, #{b} and #{c}."
end

three_things_i_like('pie', 'doggos', 'grog')

array_of_likes = %w(pie doggos grog)
three_things_i_like(*array_of_likes)

# array_of_likes = %w(pie doggos)
# three_things_i_like(*array_of_likes)

def likes(*terms)
  terms.each do |term|
    puts "I like #{term}"
  end
end

likes(*array_of_likes)
