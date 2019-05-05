def introduction(title, name:, surname:)
  puts "Hello #{title} #{name} #{surname}"
end

args = ['Mr.', { name: 'John', surname: 'Goblikon' }]
introduction(*args)
