require 'rails_helper'

  feature "users" do
    before do
        User.create!(
          first_name: "April",
          last_name: "O'Neil",
          email: "turtle@power.com",
          admin: true,
          password: "pizza",
          password_confirmation: "pizza"
        )
        User.create!(
          first_name: "Fresh",
          last_name: "Prince",
          email: "bel@air.com",
          admin: false,
          password: "80",
          password_confirmation: "80"
        )
    end
    scenario "User creates, edits, and admin destroys a user" do
      visit signin_path
      fill_in "Email", with: "turtle@power.com"
      fill_in "Password", with: "pizza"
      click_button "Sign in"
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

      page.all(:link,"Edit")[2].click
      expect(page).to have_content("Edit User")
      fill_in "First name", with: "Lucille"
      fill_in "Last name", with: "Ball"
      fill_in "Email", with: "ilove@lucy.com"
      click_button("Update User")
      expect(page).to have_content("User was successfully updated.")
      expect(page).to have_content("Lucille Ball")

      click_on("Sign Out")
      visit signin_path
      fill_in "Email", with: "turtle@power.com"
      fill_in "Password", with: "pizza"
      click_button "Sign in"
      visit users_path
      page.all(:link,"Edit")[2].click

      click_on("Delete User")
      expect(page).to have_content("User was successfully deleted")
      expect(page).to have_no_content("Lucille Ball")
      expect(page).to have_no_content("ilove@lucy.com")
    end

    scenario "When users delete users, associated data should also be deleted" do
      visit signin_path
      fill_in "Email", with: "turtle@power.com"
      fill_in "Password", with: "pizza"
      click_button "Sign in"
      visit projects_path
      click_on("Create Project")
      fill_in "Name", with: "Defeat Shredder"
      click_on("Create Project")
      expect(page).to have_content("Project was successfully created")
      expect(page).to have_content("Defeat Shredder")
      visit projects_path
      page.all(:link,"Defeat Shredder")[1].click
      click_on("1 Membership")
      within '.well' do
        select "Fresh Prince", from: "membership_user_id"
        select "Member", from: "membership_title"
        click_on("Add New Member")
      end

      click_on("Sign Out")
      visit signin_path
      fill_in "Email", with: "bel@air.com"
      fill_in "Password", with: "80"
      click_button "Sign in"
      visit projects_path
      page.all(:link,"Defeat Shredder")[1].click
      click_on("0 Tasks")
      click_on("Create Task")
      fill_in "Description", with: "Get Crisco"
      fill_in "Due date", with: "12/12/2016"
      click_button("Create Task")
      click_link("Get Crisco")
      fill_in "comment_comment", with: "This is awesome."
      click_button("Add Comment")

      click_on("Sign Out")
      visit signin_path
      fill_in "Email", with: "turtle@power.com"
      fill_in "Password", with: "pizza"
      click_button "Sign in"
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("1 Task")
      expect(page).to have_content("2 Project Members")
      expect(page).to have_content("2 Users")
      expect(page).to have_content("1 Comment")

      visit users_path
      page.all(:link,"Edit")[1].click
      click_on("Delete")
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("1 Task")
      expect(page).to have_content("1 Project Member")
      expect(page).to have_content("1 User")
      expect(page).to have_content("1 Comment")

      visit projects_path
      page.all(:link,"Defeat Shredder")[1].click
      click_on("1 Task")
      click_on("Get Crisco")
      expect(page).to have_no_content("Fresh Prince")
      expect(page).to have_content("(deleted user)")
    end

end
