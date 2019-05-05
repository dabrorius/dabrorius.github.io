require 'byebug'
puts 'Hello world1'

def likes(terms)
  terms.each do |term|
    puts "I like #{term}"
  end
end

likes(%w(pie doggos grog))

def likes(*terms)
  terms.each do |term|
    puts "I like #{term}"
  end
end

likes('pie', 'doggos', 'grog')
