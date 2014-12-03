require 'rails_helper'

  feature "tasks" do

    before do
      user = User.create!(
        first_name: "Easter",
        last_name: "Bunny",
        email: "easter@eggs.com",
        password: "chocolate",
        password_confirmation: "chocolate"
      )
       visit signin_path
       fill_in "Email", with: "easter@eggs.com"
       fill_in "Password", with: "chocolate"
       click_button "Sign in"
       click_on "Create Project"
       fill_in "Name", with: "Shampoo Carpet"
       click_button "Create Project"
    end

    scenario "User creates an empty task" do
      click_on("Create Task")
      click_button("Create Task")
      expect(page).to have_content("Description can't be blank")
    end

    scenario "User creates, edits, and destroys a correct task" do
      click_on("Create Task")
      fill_in "Description", with: "Food Fight"
      fill_in "Due date", with: "12/12/3222"
      click_button ("Create Task")
      expect(page).to have_content("Task was successfully created")
      expect(page).to have_content("Shampoo Carpet")
      expect(page).to have_content("Food Fight")
      expect(page).to have_content("False")
      expect(page).to have_content("12/12/3222")

      click_on("Edit")
      expect(page).to have_content("Edit task")
      fill_in "Description", with: "Eat Marshmallow"
      fill_in "Due date", with: "01/01/2015"
      check('Complete')
      click_button("Update Task")
      expect(page).to have_content("Task was successfully updated")
      expect(page).to have_no_content("Eat Marshmallow")
      click_on("All")
      expect(page).to have_content("Eat Marshmallow")
      expect(page).to have_content("True")
      expect(page).to have_content("01/01/2015")
      expect(page).to have_no_content("Food Fight")
      expect(page).to have_no_content("false")
      expect(page).to have_no_content("12/12/2014")

      find('.glyphicon').click
      expect(page).to have_content("Task was successfully destroyed.")
    end

    scenario "Task All / Incomplete toggle works" do
      click_on("Create Task")
      fill_in "Description", with: "Ride Tricycle"
      fill_in "Due date", with: "12/12/2016"
      click_button("Create Task")
      click_on("Edit")
      expect(page).to have_content("Edit task")
      check('Complete')
      click_button("Update Task")
      click_on("Create Task")
      fill_in "Description", with: "Use Stilts"
      fill_in "Due date", with: "12/12/2016"
      click_button "Create Task"
      click_on("All")
      expect(page).to have_content("Ride Tricycle")
      click_on("Incomplete")
      expect(page).to have_content("Use Stilts")
    end

    scenario "When a user deletes a task all related comments should be deleted" do
      click_on("Create Task")
      fill_in "Description", with: "Juggle Chain Saws"
      fill_in "Due date", with: "12/12/2016"
      click_button("Create Task")
      click_link("Juggle Chain Saws")
      fill_in "comment_comment", with: "But which door do I use to go outside?"
      click_button("Add Comment")
      visit projects_path
      page.all(:link,"Shampoo Carpet")[1].click
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("1 Task")
      expect(page).to have_content("1 Project Member")
      expect(page).to have_content("1 User")
      expect(page).to have_content("1 Comment")

      visit projects_path
      page.all(:link,"Shampoo Carpet")[1].click
      click_on("1 Task")
      find('.glyphicon').click
      visit about_path
      expect(page).to have_content("1 Project")
      expect(page).to have_content("0 Tasks")
      expect(page).to have_content("1 Project Member")
      expect(page).to have_content("1 User")
      expect(page).to have_content("0 Comments")
    end
  end
