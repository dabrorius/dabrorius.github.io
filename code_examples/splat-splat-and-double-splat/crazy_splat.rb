def likes(main_interest, *others)
  puts "I like #{main_interest} the most!"
  others.each do |other|
    puts "I also like #{other}"
  end
end

likes('pokemon', 'cats', 'chairs')

def likes(main_interest, *others, last_one)
  puts "I like #{main_interest} the most!"
  others.each do |other|
    puts "I also like #{other}"
  end
  puts "And also I kinda like #{last_one} the most!"
end

# likes('pokemon', 'cats', 'chairs')

# def likes(main_interest, *others, last_one, *and_some_more)
# end
# => syntax error, unexpected *
