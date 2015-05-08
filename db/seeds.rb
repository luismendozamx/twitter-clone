# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

50.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email = "example-#{n+1}@twitter.com"
  password = "password"
  username = "user#{n+1}"
  User.create!(first_name: first_name, last_name: last_name, username: username, email: email, password: password)
end

200.times do |n|
  content = Faker::Lorem.sentence(5)
  user_id = rand(1..50)
  Status.create!(content: content, user_id: user_id)
end
