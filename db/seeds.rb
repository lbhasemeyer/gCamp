User.delete_all
Project.delete_all
Task.delete_all
Comment.delete_all
Membership.delete_all

admin = User.create!(
  first_name: 'Admin',
  last_name: 'User',
  email: 'admin@example.com',
  password: 'password',
  admin: true,
)

owner = User.create!(
  first_name: 'Owner',
  last_name: 'User',
  email: 'owner@example.com',
  password: 'password'
)

member = User.create!(
  first_name: 'Member',
  last_name: 'User',
  email: 'member@example.com',
  password: 'password'
)

user = User.create!(
  first_name: 'Basic',
  last_name: 'User',
  email: 'user@example.com',
  password: 'password'
)

multiple_owners = Project.create!(name: 'Multiple Owners')
Membership.create!(
  project: multiple_owners,
  user: owner,
  title: 'Owner'
)
Membership.create!(
  project: multiple_owners,
  user: user,
  title: 'Owner'
)
Membership.create!(
  project: multiple_owners,
  user: member,
  title: 'Member'
)

task1 = Task.create!(
  description: "Write 3 comments",
  project: multiple_owners,
  due_date: 4.days.from_now
)

task2 = Task.create!(
  description: "Write 1 comment",
  project: multiple_owners,
  due_date: 5.days.from_now
)

3.times do
  Comment.create!(
    task: task1,
    user: owner,
    comment: Faker::Lorem.sentence
  )
end

Comment.create!(
  task: task2,
  user: member,
  comment: Faker::Lorem.sentence
)

single_owner = Project.create!(name: 'Single Owner')
Membership.create!(
  project: single_owner,
  user: owner,
  title: 'Owner'
)
Membership.create!(
  project: single_owner,
  user: member,
  title: 'Member'
)



# Task.destroy_all
# User.destroy_all
# Project.destroy_all
#
# 25.times do
#   User.create     first_name: Faker::Name.first_name,
#                   last_name: Faker::Name.last_name,
#                   email: Faker::Internet.email,
#                   password_digest: Faker::Internet.password
# end
#
# 25.times do
#   Task.create     description: Faker::Name.name,
#                   complete: Faker::Commerce.product_name,
#                   due_date: Faker::Date.forward(23)
# end
#
# 10.times do
#   Project.create   name: Faker::Commerce.product_name
#
# end
