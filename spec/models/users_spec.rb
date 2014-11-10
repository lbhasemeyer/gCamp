require 'rails_helper'

describe User do

  it 'verifies unique email for users' do
    email = "hello@kitty.com"
    User.create(
      :email => email,
      :first_name => "hello",
      :last_name => "kitty",
      :password => "hellokitty",
      )
    user = User.new(
      :first_name => "mimi",
      :last_name => "kitty",
      :password => "mimikitty",
      )
    expect(user.valid?).to be(false)
    user.email = email
    expect(user.valid?).to be(false)
    user.email = "mimi@kitty.com"
    expect(user.valid?).to be(true)
  end

end
