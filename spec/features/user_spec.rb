require 'rails_helper'

  feature "users" do
    scenario "User creates a user" do
      visit root_path
      click_on "Users"
      expect(page).to have_no_content("Ron Burgundy")
      click_on "Create User"
      click_on "Create User"
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")

      fill_in "First name", with: "Ron"
      fill_in "Last name", with: "Burgundy"
      fill_in "Email", with: "anchor@man.com"
      fill_in "Password", with: "sandiego"
      fill_in "Password confirmation", with: "sandiego"
      click_button "Create User"
      expect(page).to have_content("User was successfully created.")
      expect(page).to have_content("Ron Burgundy")
      expect(page).to have_content("anchor@man.com")

      click_on "Edit"
      expect(page).to have_content("Edit User")
      fill_in "First name", with: "Lucille"
      fill_in "Last name", with: "Ball"
      fill_in "Email", with: "ilove@lucy.com"
      click_button "Update User"
      expect(page).to have_content("User was successfully updated.")
      expect(page).to have_content("Lucille Ball")
      expect(page).to have_content("ilove@lucy.com")

      click_on "Edit"
      click_on "Delete User"
      expect(page).to have_content("User was successfully deleted")
      expect(page).to have_no_content("Lucille Ball")
      expect(page).to have_no_content("ilove@lucy.com")
    end

    scenario "When users delete users, associated data should also be deleted" do
    end

end
