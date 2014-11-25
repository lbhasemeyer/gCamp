require 'rails_helper'

  feature "projects" do
    scenario "User creates, edits, and destroys a project" do
      visit root_path
      click_on "Projects"
      expect(page).to have_no_content("Food Fortress")
      click_on "Create Project"
      click_on "Create Project"
      expect(page).to have_content("Name can't be blank")

      fill_in "Name", with: "Food Fortress"
      click_button "Create Project"
      expect(page).to have_content("Project was successfully created")
      expect(page).to have_content("Food Fortress")

      page.all(:link,"Projects")[0].click
      expect(page).to have_content("Food Fortress")
      click_on "Food Fortress"

      click_on "Edit"
      expect(page).to have_content("Edit Project")
      fill_in "Name", with: "Catch Popcorn in Mouth"
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
      expect(page).to have_content("Catch Popcorn in Mouth")

      click_on "Delete"
      expect(page).to have_no_content("Catch Popcorn in Mouth")
    end

    scenario "When a user deletes a project all related data should be deleted" do
      Project.create!(
        name: "Find Yellow Bird",
        )
      visit root_path
      click_link "Sign Up"
      fill_in "First Name", with: "Harrison"
      fill_in "Last Name", with: "Ford"
      fill_in "Email", with: "star@wars.com"
      fill_in "Password", with: "yoda"
      fill_in "Password Confirmation", with: "yoda"
      click_button "Sign Up"

      visit projects_path
      click_on "Find Yellow Bird"
      click_on "0 Tasks"
      click_on "Create Task"
      fill_in "Description", with: "Go Outside"
      fill_in "Due date", with: "12/12/2016"
      click_button "Create Task"
      click_link("Go Outside")
      fill_in "comment_comment", with: "But which door do I use to go outside?"
      click_button("Add Comment")
      visit projects_path
      click_on "Find Yellow Bird"
      click_on "0 Memberships"
      within '.well' do
        select "Harrison Ford", from: "membership_user_id"
        select "Member", from: "membership_title"
        click_on "Add New Member"
      end
      visit about_path
      expect(page).to have_content("1 Project" && "1 Task" && "1 Project Member" && "1 User" && "1 Comment")

      visit projects_path
      click_on "Find Yellow Bird"
      within '.well' do
        click_on "Delete"
      end
      visit about_path
      expect(page).to have_content("0 Projects" && "0 Tasks" && "0 Project Members" && "0 Users" && "0 Comments")
    end

  end
