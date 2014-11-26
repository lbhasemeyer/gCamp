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
    click_on("Projects")
    page.all(:link,"0")[1].click
    click_on("Create Task")
    fill_in "Description" , with: "Find Wig"
    fill_in "Due date" , with: "09/09/3009"
    click_button("Create Task")
    within 'span.badge' do
      expect(page).to have_content('0')
    end

    click_on "Find Wig"
    expect(page).to have_no_content("Add Comment")

    click_on("Sign In")
    fill_in "Email", with: "big@drum.com"
    fill_in "Password", with: "battery"
    click_button("Sign in")
    visit projects_path
    click_on("Win Elvis Impersonation Contest")
    click_on("1 Task")
    click_on("Find Wig")
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
