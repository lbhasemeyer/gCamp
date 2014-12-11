def create_user(overrides = {})
  User.create!(
    {first_name: "Frank",
    last_name: "Sinatra",
    password: "password",
    email: "frank@example.com",}.merge(overrides)
  )
end

def create_project(overrides = {})
  Project.create!(
    {name: "Ascend Mountain on Pogo Stick"}.merge(overrides)
  )
end

def create_membership(overrides = {})
  Membership.create!(
    {user: @user,
    project: @project,
    title: 'Member'}.merge(overrides)
  )
end

def create_ownership(overrides = {})
  Membership.create!(
    {user: @user2,
    project: @project,
    title: "Owner"}.merge(overrides)
  )
end


#
# def method(arg, another_arg, yet_another, opt_arg = "whatevs")
#   p arg
#   p another*4
# end
#
# method(1,2,3,"not whatevs")
