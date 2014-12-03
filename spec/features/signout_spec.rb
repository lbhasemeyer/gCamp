require 'rails_helper'

  feature "signout" do
    scenario "User signs out of gCamp" do
      User.create!(
        first_name: "Miss",
        last_name: "Piggy",
        email: "love@kermie.com",
        password: "pink",
        password_confirmation: "pink"
        )
      visit root_path
      click_on("Sign In")
      fill_in "Email", with: "love@kermie.com"
      fill_in "Password", with: "pink"
      click_button("Sign in")
      expect(page).to have_content("Miss Piggy")
      expect(page).to have_content("Sign Out")
      click_on("Sign Out")
      expect(page).to have_content("Sign Up")
      expect(page).to have_content("Sign In")
  end

end
