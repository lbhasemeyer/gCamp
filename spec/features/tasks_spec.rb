require 'rails_helper'

  feature "tasks" do
    scenario "User creates a task" do
      visit root_path
      click_on "Tasks"
      click_on "All"
      expect(page).to have_no_content("Shampoo Carpet")
      click_on "Create Task"
      fill_in "Description", with: "Shampoo Carpet"
      fill_in "Due date", with: "12/12/2014"
      click_button "Create Task"
      expect(page).to have_content("Task was successfully created")
      expect(page).to have_content("Description: Shampoo Carpet")
      expect(page).to have_content("Complete: false")
      expect(page).to have_content("Due Date: 12/12/2014")
      click_on "Back"
      expect(page).to have_content("Shampoo Carpet")
      expect(page).to have_content("False")
      expect(page).to have_content("12/12/2014")
      
      click_on "Edit"
      expect(page).to have_content("Edit task")
      fill_in "Description", with: "Eat Marshmallow"
      fill_in "Due date", with: "01/01/2015"
      check 'Complete'
      click_button "Update Task"
      expect(page).to have_content("Task was successfully updated")
      expect(page).to have_content("Description: Eat Marshmallow")
      expect(page).to have_content("Complete: true")
      expect(page).to have_content("Due Date: 01/01/2015")
      click_on "Back"
      click_on "All"
      expect(page).to have_no_content("Shampoo Carpet")
      expect(page).to have_no_content("false")
      expect(page).to have_no_content("12/12/2014")
      expect(page).to have_content("Eat Marshmallow")
      expect(page).to have_content("True")
      expect(page).to have_content("01/01/2015")

      click_on "Destroy"
      expect(page).to have_content("Task was successfully destroyed.")

      click_on "All"
      expect(page).to have_no_content("Drink H20")
      click_on "Create Task"
      fill_in "Description", with: "Drink H20"
      fill_in "Due date", with: "08/08/2026"
      click_button "Create Task"
      expect(page).to have_content("Task was successfully created")
      expect(page).to have_content("Description: Drink H20")
      expect(page).to have_content("Complete: false")
      expect(page).to have_content("Due Date: 08/08/2026")
      click_on "Edit"
      expect(page).to have_content("Edit task")

  end
end
