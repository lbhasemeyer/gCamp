require 'rails_helper'

  feature "projects" do

    before do
        User.create!(
          first_name: "Dough",
          last_name: "Boy",
          email: "bake@that.com",
          password: "dough",
          password_confirmation: "dough"
        )
        visit signin_path
        fill_in "Email", with: "bake@that.com"
        fill_in "Password", with: "dough"
        click_button "Sign in"
    end
    
    scenario "User creates, edits, and destroys a project" do
      click_on("Create Project")
      click_on("Create Project")
      expect(page).to have_content("Name can't be blank")

      fill_in "Name", with: "Food Fortress"
      click_button("Create Project")
      expect(page).to have_content("Project was successfully created")
      expect(page).to have_content("Food Fortress")
      page.all(:link,"Food Fortress")[1].click

      click_on("Edit")
      expect(page).to have_content("Edit Project")
      fill_in "Name", with: "Catch Popcorn in Mouth"
      click_button("Update Project")
      expect(page).to have_content("Project was successfully updated")
      expect(page).to have_content("Catch Popcorn in Mouth")

      click_on("Delete")
      expect(page).to have_no_content("Catch Popcorn in Mouth")
    end

    scenario "When a user deletes a project all related data should be deleted" do
      click_on("Create Project")
      fill_in "Name", with: "Breathe Fire on Unicycle"
      click_button("Create Project")

      visit projects_path
      page.all(:link,"Breathe Fire on Unicycle")[1].click
      click_on("0 Tasks")
      click_on("Create Task")
      fill_in "Description", with: "Go Outside"
      fill_in "Due date", with: "12/12/2016"
      click_button("Create Task")
      click_link("Go Outside")
      fill_in "comment_comment", with: "But which door do I use to go outside?"
      click_button("Add Comment")
      visit projects_path
      page.all(:link,"Breathe Fire on Unicycle")[1].click
      click_on("1 Membership")
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("1 Task")
      expect(page).to have_content("1 Project Member")
      expect(page).to have_content("1 User")
      expect(page).to have_content("1 Comment")

      visit projects_path
      page.all(:link,"Breathe Fire on Unicycle")[1].click
      within '.well' do
        click_on("Delete")
      end
      visit about_path
      expect(page).to have_content("0 Projects")
      expect(page).to have_content("0 Tasks")
      expect(page).to have_content("0 Project Members")
      expect(page).to have_content("1 User")
      expect(page).to have_content("0 Comments")
    end

  end
