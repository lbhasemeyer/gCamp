require 'rails_helper'

  feature "tasks" do
    scenario "User creates an empty task" do
      Project.create!(
        name: "Food Fight",
        )
      visit root_path
      click_on "Projects"
      click_on "0"
      click_on "Create Task"
      click_button "Create Task"
      expect(page).to have_content("Description can't be blank")
    end

    scenario "User creates, edits, and destroys a correct task" do
      Project.create!(
        name: "Shampoo Carpet",
        )
      visit root_path
      click_on "Projects"
      click_on "0"
      expect(page).to have_no_content("Food Fight")
      click_on "Create Task"
      fill_in "Description", with: "Food Fight"
      fill_in "Due date", with: "12/12/2014"
      click_button "Create Task"
      expect(page).to have_content("Shampoo Carpet")
      expect(page).to have_content("Task was successfully created")
      expect(page).to have_content("Food Fight")
      expect(page).to have_content("False")
      expect(page).to have_content("12/12/2014")

      click_on "Edit"
      expect(page).to have_content("Edit task")
      fill_in "Description", with: "Eat Marshmallow"
      fill_in "Due date", with: "01/01/2015"
      check 'Complete'
      click_button "Update Task"
      expect(page).to have_content("Task was successfully updated")
      expect(page).to have_content("Eat Marshmallow")
      expect(page).to have_content("True")
      expect(page).to have_content("01/01/2015")
      expect(page).to have_no_content("Food Fight")
      expect(page).to have_no_content("false")
      expect(page).to have_no_content("12/12/2014")

      click_on "Destroy"
      expect(page).to have_content("Task was successfully destroyed.")
    end

end
