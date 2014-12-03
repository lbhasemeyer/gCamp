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
       visit signin_path
       fill_in "Email", with: "big@drum.com"
       fill_in "Password", with: "battery"
       click_button "Sign in"
       click_on "Create Project"
       fill_in "Name", with: "Win Elvis Impersonation Contest"
       click_button "Create Project"
       click_on "Sign Out"
    end

    scenario "User creates a comment - but only when logged in" do
      visit root_path
      expect(page).to have_no_content("My Projects")
      click_on("Sign In")
      fill_in "Email", with: "big@drum.com"
      fill_in "Password", with: "battery"
      click_button("Sign in")
      click_on("My Projects")
      page.all(:link,"Win Elvis Impersonation Contest")[1].click
      click_on("0 Tasks")
      click_on("Create Task")
      fill_in "Description" , with: "Find Wig"
      fill_in "Due date" , with: "09/09/3009"
      click_button("Create Task")
      within 'span.badge' do
      expect(page).to have_content('0')
    end

    click_on "Find Wig"
      expect(page).to have_button("Add Comment")
      fill_in "comment_comment", with: "I looked at the grocery store..."
      click_button("Add Comment")
      expect(page).to have_content("less than a minute ago")
      expect(page).to have_content("I looked at the grocery store...")
      click_on("Tasks")
      within 'span.badge' do
        expect(page).to have_content('1')
      end
    end
  end
