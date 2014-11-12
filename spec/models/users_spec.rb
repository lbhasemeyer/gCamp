require 'rails_helper'

describe User do

  it 'verifies unique email for users' do
    email = "hello@kitty.com"
    User.create!(
      first_name: "hello",
      last_name: "kitty",
      email: email,
      password: "hellokitty",
      )
    user = User.new(
      first_name: "mimi",
      last_name: "kitty",
      password: "mimikitty",
      )
    expect(user.valid?).to be(false)
    user.email = email
    expect(user.valid?).to be(false)
    user.email = "mimi@kitty.com"
    expect(user.valid?).to be(true)
  end

  it 'verifies email is not case-sensitive' do
    User.create!(
      first_name: "Bugs",
      last_name: "Bunny",
      email: "bugs@bunny.com",
      password: "carrots",
    )
    user = User.new(
      first_name: "Elmer",
      last_name: "Fudd",
      email: "BuGs@buNnY.com",
      password: "guns",
    )
    expect(user.valid?).to be(false)
    user.email = "BUGS@BUNNY.com"
    expect(user.valid?).to be(false)
    user.email = "wabbit@get.com"
    expect(user.valid?).to be(true)
  end


end
