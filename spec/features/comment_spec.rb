require 'rails_helper'

  feature "comments" do
    before do
      user = User.create!(
        first_name: "Energizer",
        last_name: "Bunny",
        email: "big@drum.com",
        password: "battery",
        password_confirmation: "battery"
      )
    end
    scenario "User creates a comment - but only when logged in" do
    Project.create!(
      name: "Win Elvis Impersonation Contest",
      )
    visit root_path
    click_on "Projects"
    page.all(:link,"0")[1].click
    click_on "Create Task"
    fill_in "Description", with: "Find Wig"
    fill_in "Due date", with: "12/12/3019"
    click_button "Create Task"

    click_on "Find Wig"
    expect(page).to have_no_content("Add Comment")

    click_on "Sign In"
    fill_in "Email", with: "big@drum.com"
    fill_in "Password", with: "battery"
    click_button "Sign in"
    visit projects_path
    click_on("Win Elvis Impersonation Contest")
    click_on("1 Task")
    click_on("Find Wig")
    expect(page).to have_content("Add Comment")




  end
  end
