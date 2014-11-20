require 'rails_helper'

  feature "memberships" do
    before do
      project = Project.create!(
        name: "Scale Mountain on Pogo Stick"
      )
      user = User.create!(
        first_name: "Elmer",
        last_name: "Fudd",
        email: "elmer@fudd.com",
        password: "wabbit",
        password_confirmation: "wabbit"
      )
    end

    scenario "Users must enter users and roles for memberships" do
      visit projects_path
      page.all(:link,"0")[0].click
      click_on "Add New Member"
      expect(page).to have_content("User can't be blank")
    end

    scenario "Users can add members to projects" do
      visit projects_path
      page.all(:link,"0")[0].click
      select "Elmer Fudd", from: "membership_user_id"
      select "Owner", from: "membership_title"
      click_on "Add New Member"
      expect(page).to have_content("Membership was successfully created.")
      expect(page).to have_content("Elmer Fudd")
      expect(page).to have_content("Owner")
      expect(page).to have_content("Update")
    end

  scenario "Users cannot add the same member to a project twice" do
    visit projects_path
    page.all(:link,"0")[0].click
    select "Elmer Fudd", from: "membership_user_id"
    select "Owner", from: "membership_title"
    click_on "Add New Member"
    select "Elmer Fudd", from: "membership_user_id"
    click_on "Add New Member"
    expect(page).to have_content("User has already been added")
  end

  scenario "Users can be added to multiple projects" do
    project = Project.create!(
      name: "Make River of Cheese"
    )
    visit projects_path
    page.all(:link,"0")[0].click
    select "Elmer Fudd", from: "membership_user_id"
    select "Owner", from: "membership_title"
    click_on "Add New Member"
    expect(page).to have_content("Membership was successfully created.")

    visit projects_path
    click_on "Make River of Cheese"
    click_on "0 Members"
    select "Elmer Fudd", from: "membership_user_id"
    select "Member", from: "membership_title"
    click_on "Add New Member"
    expect(page).to have_content("Membership was successfully created.")
  end

  scenario "Users can change the role of project members" do

  end

  end
