require 'rails_helper'

  feature "tasks" do
    scenario "User creates an empty task" do
      Project.create!(
        name: "Food Fight",
        )
      visit root_path
      click_on "Projects"
      page.all(:link,"0")[1].click
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
      page.all(:link,"0")[1].click
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
      expect(page).to have_no_content("Eat Marshmallow")
      click_on "All"
      expect(page).to have_content("Eat Marshmallow")
      expect(page).to have_content("True")
      expect(page).to have_content("01/01/2015")
      expect(page).to have_no_content("Food Fight")
      expect(page).to have_no_content("false")
      expect(page).to have_no_content("12/12/2014")

      click_on "Destroy"
      expect(page).to have_content("Task was successfully destroyed.")
    end

    scenario "Task All / Incomplete toggle works" do
      project = Project.create!(
        name: "Shampoo Carpet"
        )
      visit root_path
      click_on "Projects"
      page.all(:link,"0")[1].click
      expect(page).to have_no_content("Food Fight")
      click_on "Create Task"
      fill_in "Description", with: "Ride Tricycle"
      fill_in "Due date", with: "12/12/2016"
      click_button "Create Task"
      click_on "Edit"
      expect(page).to have_content("Edit task")
      check 'Complete'
      click_button "Update Task"
      click_on "Create Task"
      fill_in "Description", with: "Use Stilts"
      fill_in "Due date", with: "12/12/2016"
      click_button "Create Task"
      click_on "All"
      expect(page).to have_content("Ride Tricycle")
      click_on "Incomplete"
      expect(page).to have_content("Use Stilts")
    end

end
