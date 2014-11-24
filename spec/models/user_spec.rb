require 'rails_helper'

describe User do

  it 'verifies unique email for users' do
    email = "hello@kitty.com"
    User.create!(
      first_name: "hello",
      last_name: "kitty",
      email: "hello@kitty.com",
      password: "hellokitty",
      )
    user = User.new(
      first_name: "mimi",
      last_name: "kitty",
      email: "hello@kitty.com",
      password: "mimikitty",
      )
    user.valid?
    expect(user.errors[:email].present?).to eq(true)
    user.email = "mimi@kitty.com"
    user.valid?
    expect(user.errors[:email].present?).to eq(false)
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
    user.valid?
    expect(user.errors[:email].present?).to eq(true)
    user.email = "BUGS@BUNNY.com"
    user.valid?
    expect(user.errors[:email].present?).to eq(true)
    user.email = "wabbit@get.com"
    user.valid?
    expect(user.errors[:email].present?).to eq(false)
  end


end
