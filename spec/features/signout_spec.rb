require 'rails_helper'

  feature "signout" do
    scenario "User signs out of gCamp" do
      visit root_path
      click_on "Sign Up"
      fill_in "First name", with: "Miss"
      fill_in "Last name", with: "Piggy"
      fill_in "Email", with: "love@kermie.com"
      fill_in "Password", with: "pink"
      fill_in "Password confirmation", with: "pink"
      click_button "Sign Up"
      click_on "Sign Out"
      expect(current_path).to eq root_path

      visit root_path
      click_on "Sign In"
      fill_in "Email", with: "love@kermie.com"
      fill_in "Password", with: "pink"
      click_button "Sign in"
      click_on "Sign Out"
  end

end
