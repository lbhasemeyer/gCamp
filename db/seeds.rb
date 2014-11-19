Task.delete_all
User.delete_all
Project.delete_all

25.times do
  User.create     first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: Faker::Internet.email,
                  password_digest: Faker::Internet.password
end

25.times do
  Task.create     description: Faker::Name.name,
                  complete: Faker::Commerce.product_name,
                  due_date: Faker::Date.forward(23)
end

10.times do
  Project.create   name: Faker::Commerce.product_name

end
