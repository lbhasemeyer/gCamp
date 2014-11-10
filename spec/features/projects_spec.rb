require 'rails_helper'

  feature "projects" do
    scenario "User creates a project" do
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

      click_on "Projects"
      expect(page).to have_content("Food Fortress")
      click_on "Food Fortress"

      click_on "Edit"
      expect(page).to have_content("Edit Project")
      fill_in "Name", with: "Catch Popcorn in Mouth"
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
      expect(page).to have_content("Catch Popcorn in Mouth")

      click_on "Destroy"
      expect(page).to have_no_content("Catch Popcorn in Mouth")
  end

end
