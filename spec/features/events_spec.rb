require 'rails_helper'

 feature "signup" do
  scenario "User signs up for gCamp" do
    visit root_path
    expect(page).to have_content("Sign Up")
    click_on "Sign Up"
    fill_in "First name", with: "Babe"
    fill_in "Last name", with: "Ruth"
    fill_in "Email", with: "babe@ruth.com"
    fill_in "Password", with: "baseball"
    fill_in "Password confirmation", with: "baseball"
    click_button 'Sign Up'
    expect(current_path).to eq root_path
    expect(page).to have_content("Babe Ruth")
    expect(page).to have_content("Sign Out")
  end


feature "signin" do
  scenario "User signs into gCamp" do
    User.create!(
      :first_name => 'Mr',
      :last_name => "Bean";
      :email => "mr@bean.com";
      :password => "bean";
      :password_confirmation => "bean"
    )

    visit root_path
    expect(page).to have_content("Sign In")
    click_on "Sign In"
    fill_in "Email", with: "mr@bean.com"
    fill_in "Password", with: "bean"
    click_button "Sign In"
    expect(page).to have_content("Mr Bean")
    expect(page).to have_no_content("Sign Out")
  end




end
