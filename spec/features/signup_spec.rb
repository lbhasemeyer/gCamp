require 'rails_helper'

 feature "signup" do
  scenario "User signs up for gCamp" do
    visit root_path
    click_on("Sign Up")
    click_button("Sign Up")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")

    fill_in "First Name", with: "Babe"
    fill_in "Last Name", with: "Ruth"
    fill_in "Email", with: "babe@ruth.com"
    fill_in "Password", with: "baseball"
    fill_in "Password Confirmation", with: "baseball"
    click_button("Sign Up")
    expect(current_path).to eq root_path
    expect(page).to have_content("Babe Ruth")
    expect(page).to have_content("Sign Out")
    expect(page).to have_no_content("Sign In")
    expect(page).to have_no_content("Sign Up")

    click_on("Babe Ruth")
    expect(page).to have_content("Babe Ruth")
    expect(page).to have_content("First Name: Babe")
    expect(page).to have_content("Last Name: Ruth")
    expect(page).to have_content("Email: babe@ruth.com")

  end

end
