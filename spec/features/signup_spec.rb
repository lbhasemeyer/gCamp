require 'rails_helper'

 feature "signup" do
  scenario "User signs up for gCamp" do
    visit root_path
    click_on "Sign Up"
    click_button "Sign Up"
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
    fill_in "First name", with: "Babe"
    fill_in "Last name", with: "Ruth"
    fill_in "Email", with: "babe@ruth.com"
    fill_in "Password", with: "baseball"
    fill_in "Password confirmation", with: "baseball"
    click_button "Sign Up"
    expect(current_path).to eq root_path
    expect(page).to have_content("Babe Ruth")
    expect(page).to have_content("Sign Out")

    click_on "Babe Ruth"
    expect(page).to have_content("Babe Ruth")
    expect(page).to have_content("First Name: Babe")
    expect(page).to have_content("Last Name: Ruth")
    expect(page).to have_content("Email: babe@ruth.com")
  end

end
