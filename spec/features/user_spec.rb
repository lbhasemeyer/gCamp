require 'rails_helper'

  feature "users" do
    scenario "User creates a user" do
      visit users_path
      expect(page).to have_no_content("Ron Burgundy")
      click_on("Create User")
      click_on("Create User")
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")

      fill_in "First name", with: "Ron"
      fill_in "Last name", with: "Burgundy"
      fill_in "Email", with: "anchor@man.com"
      fill_in "Password", with: "sandiego"
      fill_in "Password confirmation", with: "sandiego"
      click_button("Create User")
      expect(page).to have_content("User was successfully created.")
      expect(page).to have_content("Ron Burgundy")
      expect(page).to have_content("anchor@man.com")

      click_on("Edit")
      expect(page).to have_content("Edit User")
      fill_in "First name", with: "Lucille"
      fill_in "Last name", with: "Ball"
      fill_in "Email", with: "ilove@lucy.com"
      click_button("Update User")
      expect(page).to have_content("User was successfully updated.")
      expect(page).to have_content("Lucille Ball")
      expect(page).to have_content("ilove@lucy.com")

      click_on("Edit")
      click_on("Delete User")
      expect(page).to have_content("User was successfully deleted")
      expect(page).to have_no_content("Lucille Ball")
      expect(page).to have_no_content("ilove@lucy.com")
    end

    scenario "When users delete users, associated data should also be deleted" do
      Project.create!(
        name: "Break Mug",
        )
      visit root_path
      click_on("Sign Up")
      fill_in "First Name", with: "April"
      fill_in "Last Name", with: "O'Neil"
      fill_in "Email", with: "turtle@power.com"
      fill_in "Password", with: "pizza"
      fill_in "Password Confirmation", with: "pizza"
      click_button("Sign Up")

      visit projects_path
      click_on("Break Mug")
      click_on("0 Tasks")
      click_on("Create Task")
      fill_in "Description", with: "Get Crisco"
      fill_in "Due date", with: "12/12/2016"
      click_button("Create Task")
      click_link("Get Crisco")
      fill_in "comment_comment", with: "This is awesome."
      click_button("Add Comment")
      visit projects_path
      click_on("Break Mug")
      click_on("0 Memberships")
      within '.well' do
        select "April O'Neil", from: "membership_user_id"
        select "Member", from: "membership_title"
        click_on("Add New Member")
      end
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("1 Task")
      expect(page).to have_content("1 Project Member")
      expect(page).to have_content("1 User")
      expect(page).to have_content("1 Comment")

      visit users_path
      click_link("Edit")
      click_on("Delete")
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("1 Task")
      expect(page).to have_content("0 Project Members")
      expect(page).to have_content("0 Users")
      expect(page).to have_content("1 Comment")

      visit projects_path
      click_on("Break Mug")
      click_on("1 Task")
      click_on("Get Crisco")
      expect(page).to have_no_content("April O'Neil")
      expect(page).to have_content("(deleted user)")

    end

end
