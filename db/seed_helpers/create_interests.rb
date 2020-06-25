def create_interests
  interests = [
    { name: 'Business'},
    { name: 'Entertainment'},
    { name: 'General'},
    { name: 'Health'},
    { name: 'Science'},
    { name: 'Sports'},
    { name: 'Technology'}
  ]

  interests.each { |i| Interest.create(i) }
end